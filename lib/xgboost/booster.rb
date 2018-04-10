require 'ffi'

module Xgboost
  class Booster
    def initialize
      @handle = ::FFI::MemoryPointer.new(:pointer)
      FFI.XGBoosterCreate(nil, 0, @handle)
      self.class.define_finalizer(self)
    end

    def self.define_finalizer(obj)
      # TODO I wouldn't be surprised if this didn't work,
      # the block keeps a reference to obj, so obj
      # will never be GC'd
      ObjectSpace.define_finalizer(obj) { obj.free! }
    end

    def load(path)
      FFI.XGBoosterLoadModel(handle_pointer, path)
    end

    def save(path)
      FFI.XGBoosterSaveModel(handle_pointer, path)
    end

    def free!
      FFI.XGBoosterFree(handle_pointer)
    end

    def predict(input, missing: Float::NAN)
      raise TypeError unless input.is_a?(Array)

      unless input_2d = input.first.is_a?(Array)
        input = [input]
      end

      out_len = ::FFI::MemoryPointer.new(:ulong_long)
      out_result = ::FFI::MemoryPointer.new(:pointer)

      data = ::FFI::MemoryPointer.new(:float, input.count * input.first.count)
      data.put_array_of_float(0, input.flatten)

      dmatrix = ::FFI::MemoryPointer.new(:pointer)
      FFI.XGDMatrixCreateFromMat(data, input.count, input.first.count, missing, dmatrix)

      FFI.XGBoosterPredict(handle_pointer, dmatrix.read_pointer, 0, 0, out_len, out_result)

      out = out_result.read_pointer.read_array_of_float(out_len.read_ulong_long)

      input_2d ? out : out.first
    ensure
      FFI.XGDMatrixFree(dmatrix.read_pointer) if dmatrix
    end

    private

    def handle_pointer
      @handle.read_pointer
    end
  end
end
