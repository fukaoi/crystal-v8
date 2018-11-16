@[Link(ldflags:
 " #{__DIR__}/../../libv8/libv8_wrapper.so \
  -licui18n \
  -lv8_libplatform \
  -licuuc \
  -lv8_libbase \
  -lv8 \
  -L#{__DIR__}/../../libv8 \
  -lstdc++"
)]

lib LibV8
  fun init : Void
  fun eval(code : LibC::Char*) : LibC::Char*
  fun destroy : Void
end
