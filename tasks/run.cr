require "./defined"

class Run < LuckyCli::Task
  banner "running v8 wrapper binary"

  def initialize
    return if ARGV != ["run"]
    case ENV["LUCKY_ENV"]
    when "release"
      @wrapper = V8_RELEASR_RAPPER
    when "development"
      @wrapper = V8_DEVELOPMENT_RAPPER
    when "test"
      @wrapper = V8_TEST_RAPPER
    when "v8wrapper"
      @wrapper = V8_WRAPPER
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
  end

  def call
    system("./bin/#{@wrapper}")
  end
end
