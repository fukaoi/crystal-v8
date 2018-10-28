@[Link(ldflags: "#{__DIR__}/hello.o")]

lib Say
  fun hello(name : LibC::Char*) : Void
end

Say.hello("てすとだよーん")
