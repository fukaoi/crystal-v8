require "./spec_helper"

v8 = V8::JS.new
describe V8::JS do
  it "Calculate" do
    res = v8.eval("10 + 20")
    res.should eq "30"
  end

  it "Primitive function" do
    res = v8.eval("new Date()")
    res.should_not be_nil
  end

  it "const, let ES6 feature" do
    res = v8.eval("const a = 10;let b = 20;a + b;")
    res.should eq "30"
  end

  it "Class object" do
    res = v8.eval("class Person {
      constructor(name) {
        this.name = name;
      }
      hello() {
        return (\"Hello, I'm \" + this.getName());
      }
      getName() {
        return this.name;
      }
    }; new Person('Mike Davis').hello();")
    res.should eq "Hello, I'm Mike Davis"
  end

  it "Anonymous function" do
    res = v8.eval("const fn = function(num){return num * 40};fn(10)")
    res.should eq "400"
  end

  it "Run external file" do
    calling = "const math = require('mathjs');math.log(10000, 10);"
    code = File.read("#{__DIR__}/tools/stellar-sdk.js")
    res = v8.eval("#{calling}")
  end
end
v8.destructor
