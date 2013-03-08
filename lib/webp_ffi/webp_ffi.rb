require "webp_ffi/c"

module WebpFfi
  class << self
    
    def decoder_version
      pointer = FFI::MemoryPointer.new(:char, 10)
      C.decoder_version(pointer)
      pointer.null? ? nil : pointer.read_string()
    end
    
    def encoder_version
      pointer = FFI::MemoryPointer.new(:char, 10)
      C.encoder_version(pointer)
      pointer.null? ? nil : pointer.read_string()
    end
    
    # get webp image size
    def webp_size(data)
      return nil if data.nil?
      width_ptr = FFI::MemoryPointer.new(:int, 2)
      height_ptr = FFI::MemoryPointer.new(:int, 2)
      size = data.respond_to?(:bytesize) ? data.bytesize : data.size
      memBuf = FFI::MemoryPointer.new(:char, size)
      memBuf.put_bytes(0, data)
      if C.webp_get_info(memBuf, size, width_ptr, height_ptr) == 1
        [width_ptr.null? ? nil : width_ptr.read_int, height_ptr.null? ? nil : height_ptr.read_int]
      else
        raise InvalidImageFormatError, "invalid webp image"
        return nil
      end
    end
    
    def webp_decode_rgba(data)
      return nil if data.nil?
      width_ptr = FFI::MemoryPointer.new(:int, 2)
      height_ptr = FFI::MemoryPointer.new(:int, 2)
      size = data.respond_to?(:bytesize) ? data.bytesize : data.size
      memBuf = FFI::MemoryPointer.new(:char, size)
      memBuf.put_bytes(0, data)
      pointer = C.webp_decode_rgba(memBuf, size, width_ptr, height_ptr)
      pointer.null? ? nil : pointer.read_string()
    end
    
  end
end