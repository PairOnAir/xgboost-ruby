require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']
RbConfig::MAKEFILE_CONFIG['CXX'] = ENV['CXX'] if ENV['CXX']

root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
target = File.expand_path(File.join(root, 'vendor', 'xgboost'))

`#{root}/bin/install_xgboost.sh`

dir_config('xgboost', File.join(target, 'include'), File.join(target, 'lib'))
dir_config('rabit', File.join(target, 'rabit', 'include'), File.join(target, 'rabit', 'lib'))

unless find_header('xgboost/c_api.h')
  abort 'xgboost not found please make sure it is installed'
end

unless find_library('xgboost', 'XGBoosterCreate')
  abort 'xgboost not found please make sure it is installed'
end

create_makefile('xgboost/xgboost')
