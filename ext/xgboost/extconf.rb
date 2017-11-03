require 'mkmf'

HEADER_DIRS = [
 '../../../../../xgboost/include',
 '../../../../../xgboost/rabit/include',
]

LIB_DIRS = [
  '../../../../../xgboost/lib',
  '../../../../../xgboost/rabit/lib',
]

dir_config('xgboost', HEADER_DIRS, LIB_DIRS)

unless find_header('xgboost/c_api.h')
  abort 'xgboost not found please make sure it is installed'
end

unless find_library('xgboost', 'XGBoosterCreate')
  abort 'xgboost not found please make sure it is installed'
end

create_makefile("xgboost/xgboost")
