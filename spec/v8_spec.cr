require "./spec_helper"

describe V8 do
  it "Run simple JS code" do
    v8 = V8::JS.new
    result = v8.eval("10 + 20")
    !p result
    # JS.eval("new Date()")
    # JS.eval("const a = 10;let b = 10;a + b;")
  end

  # it "Run JS class or function code" do
  #   JS.eval("class Person {
  #     constructor(name) {
  #       this.name = name;
  #     }
  #     hello() {
  #       return (\"Hello, I'm \" + this.getName());
  #     }
  #     getName() {
  #       return this.name;
  #     }
  #   }; new Person('Mike Davis').hello();")
  #   JS.eval("const fn = function(a){return a * 40};fn(10)")
  #   JS.eval("function exec(a) {return a * 50};exec(10)")
  # end
end
