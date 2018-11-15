@[Link(ldflags:
  "-lv8_bridge \
  -licui18n \
  -lv8_libplatform \
  -licuuc \
  -lv8_libbase \
  -lv8 \
  -L#{__DIR__}/ext \
  -L/opt/libv8-6.6/lib \
  -lstdc++"
)]

lib LibV8
  fun init : Void
  fun eval(code : LibC::Char*) : LibC::Char*
  fun destroy : Void
end

LibV8.init
puts LibV8.eval("1+1")
LibV8.destroy


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
    end

    def destructor
      LibV8.destroy
    end
  end
end

