require "./defined"

class Run < LuckyCli::Task
  banner "running v8 binary_name binary"

  def initialize
    return if ARGV != ["run"]
    case ENV["LUCKY_ENV"]
    when "release"
      @binary_name = V8_RELEASE
    when "development"
      @binary_name = V8_DEVELOPMENT
    when "test"
      @binary_name = V8_TEST
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
  end

  def call
    system("./bin/#{@binary_name}")
  end
end
