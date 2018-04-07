module Xgboost
  class Booster
    def initialize
      @handle = FFI::MemoryPointer.new(:pointer) do |handle|
        Native.XGBoosterFree(handle.read_pointer)
      end
      Native.XGBoosterCreate(nil, 0, @handle)
    end

    def load(path)
      Native.XGBoosterLoadModel(handle_pointer, path)
    end

    def predict(input)
      raise TypeError unless input.is_a?(Array)
      dmatrix = to_dmatrix(input)
      out_len = FFI::MemoryPointer.new(:ulong_long)
      out_result = FFI::MemoryPointer.new(:pointer)

      args = [handle_pointer, dmatrix.read_pointer, 0, 0, out_len, out_result]
      puts "Before XGBoosterPredict args: #{args.join(" | ")}"
      debugger
      Native.XGBoosterPredict(*args)

      out_result.read_array_of_float(out_len.read_uint)
    end

    private

    def handle_pointer
      @handle.read_pointer
    end

    def to_dmatrix(input)
      data = FFI::MemoryPointer.new(:float, input.count)
      data.put_array_of_float(0, input)

      dmatrix_handle = FFI::MemoryPointer.new(:pointer) do |handle|
        Native.XGDMatrixFree(handle.read_pointer)
      end
      Native.XGDMatrixCreateFromMat(data, 1, input.count, 0, dmatrix_handle)

      dmatrix_handle
    end
  end
end
