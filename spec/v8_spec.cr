require "./spec_helper"

describe V8 do
  # TODO: Write tests

  it "works" do
    V8.run("1 + 1")
# V8::JS.eval("new Date()")
# V8.eval("const a = 10;let b = 10;a + b;")
# V8.eval("class Person {
#   constructor(name) {
#     this.name = name;
#   }
#   V8Hello() {
#     return (\"Hello, I'm \" + this.getName());
#   }
#   getName() {
#     return this.name;
#   }
# }; new Person('山田敬三').V8Hello();")
# V8.eval("const fn = function(a){return a * 999};fn(10)")
# V8.eval("function exec(a) {return a * 555};exec(10)")
# V8::JS.destroy


  end
end

