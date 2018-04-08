require 'ffi'

module Xgboost
  module FFI
    extend ::FFI::Library
    ffi_lib 'xgboost'

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
