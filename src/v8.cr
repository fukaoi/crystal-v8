@[Link(ldflags:
  "-lv8_wrapper \
  -licui18n \
  -lv8_libplatform \
  -licuuc \
  -lv8_libbase \
  -lv8 \
  -L#{__DIR__}/ext \
  -lstdc++"
)]

lib LibV8
  fun init : Void
  fun eval(code : LibC::Char*) : LibC::Char*
  fun destroy : Void
end

module V8
  class JS
    def initialize
      LibV8.init
    end

    def eval(code : String)
      pointer = LibV8.eval(code)
      String.new(pointer)
    rescue exception
      !pp "todo: #{exception}"
    ensure
      LibV8.destroy
    end
  end
end

