require 'ffi'

module Xgboost
  module FFI
    extend ::FFI::Library
    lib_name = ::FFI.map_library_name('xgboost')
    lib_path = File.join(Xgboost.root, 'vendor', 'xgboost', 'lib', lib_name)

    begin
      ffi_lib ['xgboost', lib_path]
    rescue LoadError => e
      abort <<~HELP

        Cannot load libxgboost! Looked in:
          - /usr/lib
          - /usr/local/lib
          - #{lib_path}

        You can either:
          1. (easiest) Run `rake -r xgboost/rake xgboost:install`

             This will clone and compile the latest version of dmlc/xgboost, as per
             https://github.com/PairOnAir/xgboost-ruby/tree/v#{VERSION}/bin/install_xgboost.

          2. (easy, stable) Run `rake -r xgboost/rake xgboost:install[GIT_SHA]`

             This will clone and compile the given commit SHA1 of dmlc/xgboost. This way you're
             making sure you're locking to the same version of XGBoost across development,
             CI, staging, and production.

          3. (full control) Compile xgboost yourself and put it in /usr/local/lib, e.g.:

             git clone --recurse-submodules https://github.com/dmlc/xgboost.git && cd xgboost && make
             ln -s $(pwd)/lib/#{lib_name} /usr/local/lib
             # or: cp $(pwd)/lib/#{lib_name} /usr/local/lib

             Depending on your platform, compiling xgboost from source
             will probably be more tricky than that, please consult the
             XGBoost docs for help: http://xgboost.readthedocs.io/en/latest/build.html.

        Exception details:
        #{e}

      HELP
    end

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
