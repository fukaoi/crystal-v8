@[Link(ldflags: "#{__DIR__}/hello.o")]

lib Say
  fun hello(name : LibC::Char*) : Void
end

Say.hello("your name")

@[Link(ldflags: "#{__DIR__}/jslib.o  -lstdc++ #{__DIR__}/libv8_libplatform.so #{__DIR__}/libicui18n.so #{__DIR__}/libicuuc.so #{__DIR__}/libv8_libbase.so  #{__DIR__}/libv8.so")]

lib Say
  fun jslib : Void
end

Say.jslib
