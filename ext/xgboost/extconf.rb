require 'mkmf'

def say_and_run(cmd)
  puts "About to run: #{cmd}"
  `#{cmd}`
end

target = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'xgboost'))

FileUtils.mkdir_p(target)

# clone xgboost
say_and_run("git clone --recursive --jobs 4 --depth 1 git@github.com:dmlc/xgboost.git #{target}")
say_and_run("cd #{target}; git submodule update --remote")

# run make in xgboost
say_and_run("cd #{target}; cp make/minimum.mk config.mk; make -j 4")

# run install name tool to fix library reference
say_and_run("cd #{target}; install_name_tool -id '#{target}/lib/libxgboost.dylib' lib/libxgboost.dylib")

HEADER_DIRS = [
  File.join(target, 'include'),
  File.join(target, 'rabit', 'include'),
]

LIB_DIRS = [
  File.join(target, 'lib'),
  File.join(target, 'rabit', 'lib'),
]

dir_config('xgboost', HEADER_DIRS, LIB_DIRS)

unless find_header('xgboost/c_api.h')
  abort 'xgboost not found please make sure it is installed'
end

unless find_library('xgboost', 'XGBoosterCreate')
  abort 'xgboost not found please make sure it is installed'
end

create_makefile("xgboost/xgboost")
