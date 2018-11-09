require "./defined"

class Run < LuckyCli::Task
  banner "running v8 wrapper binary"

  def initialize
    return if ARGV != ["run"]
    case ENV["LUCKY_ENV"]
    when "release"
      @wrapper = V8_RELEASR
    when "development"
      @wrapper = V8_DEVELOPMENT
    when "test"
      @wrapper = V8_TEST
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
  end

  def call
    system("LD_LIBRARY_PATH=`pwd`/src/ext ./bin/#{@wrapper}")
  end
end
