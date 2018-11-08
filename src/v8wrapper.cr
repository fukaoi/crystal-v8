require "file_utils"

@[Link(ldflags: " \
  #{__DIR__}/../lib/v8wrapper.o \
  #{__DIR__}/../lib/libicui18n.so \
  #{__DIR__}/../lib/libv8_libplatform.so \
  #{__DIR__}/../lib/libicuuc.so \
  #{__DIR__}/../lib/libv8_libbase.so \
  #{__DIR__}/../lib/libv8.so \
  -lstdc++"
)]
lib JS
  fun init(path : LibC::Char*) : Void
  fun eval(code : LibC::Char*) : Void
  fun destroy : Void
end

JS.init("./bin/v8wrapper")
JS.eval("new Date()")
JS.eval("const a = 10;let b = 10;a + b;")
JS.eval("class Person {
  constructor(name) {
    this.name = name;
  }
  JSHello() {
    return (\"Hello, I'm \" + this.getName());
  }
  getName() {
    return this.name;
  }
}; new Person('山田敬三').JSHello();")
JS.eval("const fn = function(a){return a * 999};fn(10)")
JS.eval("const fn2 = (a)=> {return a * 555};fn2(10)")
JS.destroy

