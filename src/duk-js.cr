require "./duk-js/*"
require "duktape"

module Duk::Js
  def self.run
    sbx = Duktape::Sandbox.new
    sbx.eval! <<-JS
      var birthYear = 1990;
      function calcAge(birthYear) {
        var current = new Date();
        var year = current.getFullYear();
        return year - birthYear;
      }

      print("You are " + calcAge(birthYear));
    JS
  end

  def self.run_js
    !pp @@file = File.read("./stellar-base.min.js")
    sbx = Duktape::Sandbox.new
    sbx.eval! <<-JS
      #{@@file}
    JS
  end
end

#Duk::Js.run
Duk::Js.run_js
