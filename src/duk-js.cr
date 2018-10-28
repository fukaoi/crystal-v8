# @[Link(ldflags: "#{__DIR__}/hello.o")]

# lib Say
#   fun hello(name : LibC::Char*) : Void
# end

# Say.hello("your name")

@[Link(ldflags: "#{__DIR__}/jslib.o")]

lib Say
  fun jslib : Void
end

Say.jslib
