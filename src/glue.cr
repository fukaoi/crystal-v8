require "file_utils"

#### gn config ####
# is_component_build = true
# is_debug = true
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = false
# v8_use_external_startup_data = false
# v8_static_library = true

@[Link(ldflags: " \
  #{__DIR__}/../lib/glue.o \
  #{__DIR__}/../lib/libicui18n.so \
  #{__DIR__}/../lib/libv8_libplatform.so \
  #{__DIR__}/../lib/libicuuc.so \
  #{__DIR__}/../lib/libv8_libbase.so \
  #{__DIR__}/../lib/libv8.so \
  -lstdc++"
)]
lib Say
  fun jslib(jscode : LibC::Char*) : Void
end

#!pp LibC.strlen("test")
#!pp LibC.strlen("てすとだお")

Say.jslib("new Date()")
Say.jslib("new Date()")
Say.jslib("new Date()")
Say.jslib("const a = 10;let b = 10;a + b;")
Say.jslib("class Person {
  constructor(name) {
    this.name = name;
  }
  sayHello() {
    return (\"Hello, I'm \" + this.getName());
  }
  getName() {
    return this.name;
  }
}; new Person('山田敬三').sayHello();")
Say.jslib("const fn = function(a){return a * 999};fn(10)")
Say.jslib("const fn = (a)=> {return a * 555};fn(10)")


