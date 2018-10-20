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
end

Duk::Js.run
