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

lib JS
  fun init : Void
  fun eval(code : LibC::Char*) : LibC::Char*
  fun destroy : Void
end

module V8
end

