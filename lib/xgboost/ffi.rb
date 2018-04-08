require 'ffi'

module Xgboost
  module FFI
    extend ::FFI::Library
    lib_name = ::FFI.map_library_name('xgboost')
    lib_path = File.expand_path(File.join('..', '..', '..', 'vendor', 'xgboost', 'lib', lib_name), __FILE__)
    ffi_lib ['xgboost', lib_path]

    {
      XGBoosterCreate: %i[ pointer long pointer ],
      XGBoosterFree: %i[ pointer ],
      XGBoosterLoadModel: %i[ pointer string ],
      XGBoosterSaveModel: %i[ pointer string ],
      XGBoosterPredict: %i[ pointer pointer int uint pointer pointer ],
      XGDMatrixCreateFromMat: %i[ pointer long long float pointer ],
      XGDMatrixFree: %i[ pointer ],
    }.each do |function, args|
      attach_function function, args, :int
    end

  end
end
