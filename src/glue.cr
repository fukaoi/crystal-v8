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
  fun init : Void
  fun run(jscode : LibC::Char*) : Void
  fun finalyze : Void
end

#!pp LibC.strlen("test")
#!pp LibC.strlen("てすとだお")
Say.init
Say.run("new Date()")
Say.run("new Date()")
Say.run("new Date()")
Say.run("const a = 10;let b = 10;a + b;")
Say.run("class Person {
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
Say.run("const fn = function(a){return a * 999};fn(10)")
Say.run("const fn = (a)=> {return a * 555};fn(10)")
Say.finalyze

