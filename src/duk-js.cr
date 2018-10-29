@[Link(ldflags: "#{__DIR__}/jslib.o  -lstdc++ #{__DIR__}/libicui18n.so #{__DIR__}/libv8_libplatform.so  #{__DIR__}/libicuuc.so #{__DIR__}/libv8_libbase.so  #{__DIR__}/libv8.so")]

lib Say
  fun jslib(jscode : LibC::Char*) : Void
end

Say.jslib("new Date()")
