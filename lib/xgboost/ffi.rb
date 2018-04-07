require 'ffi'

module Xgboost
  module FFI
    extend ::FFI::Library
    ffi_lib 'libxgboost'

    {
      XGBoosterCreate: %i[ pointer long pointer ],
      XGBoosterLoadModel: %i[ pointer string ],
      XGBoosterFree: %i[ pointer ],
      XGBoosterPredict: %i[ pointer pointer int uint pointer pointer ],
      XGDMatrixCreateFromMat: %i[ pointer long long float pointer ],
      XGDMatrixFree: %i[ pointer ],
    }.each do |function, args|
      attach_function function, args, :int
    end

  end
end
