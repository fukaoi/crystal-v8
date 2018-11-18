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

  it "Load js file" do
    code = File.read("#{__DIR__}/support/fn.js")
    call = "demo('Calling for spec test');"
    puts v8.eval("#{code};#{call}")
  end

  it "async()" do
    main_code = <<-CMD
    (async() => {
      const dataList = await Promise.all([
      fetch('https://qiita.com/api/v2/tags/Node.js'),
      fetch('https://qiita.com/api/v2/tags/JavaScript'),
      fetch('https://qiita.com/api/v2/tags/npm'),
    ]);
    for (const data of dataList) {
      console.log(data);
    }
    })();
    CMD
    puts v8.eval(main_code)
  end

  it "import()" do
    main_code = <<-CMD
      //import('./support/fn.js')
      demo('import function OK!!!!')
    CMD
    puts v8.eval(main_code)
  end

  it "promise()" do
    main_code = <<-CMD
    Promise.resolve("resolve")
    .then(val => {console.log(val);return "then"})
    .then(val => {console.log(val);throw new Error("catch")})
    .catch(err => {console.log(err.message)})
    .finally(() => {console.log("finally")});
    CMD
    puts v8.eval(main_code)
  end

  it "Not work function" do
    main_code = <<-CMD
      /*
      exports.data = {
        a: 10,
        b: 20
      }
      */
      //console.log(1);
      //require('./support/fn.js')
      //module.exports = {}
      fs = import('hogehoge');
    CMD
    puts v8.eval(main_code)
  end
end
v8.destructor
