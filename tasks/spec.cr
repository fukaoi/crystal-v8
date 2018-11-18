require "lucky_cli"

class Spec < LuckyCli::Task
  banner "Spec all test and spec file select test"

  def call
    if ARGV.size > 0
      raise Exception.new("Failed a spec") unless system("LD_LIBRARY_PATH=`pwd`/#{LIBRARY_DIR} crystal spec -v #{ARGV[0]}")
    else
      raise Exception.new("Failed all spec") unless system("LD_LIBRARY_PATH=`pwd`/#{LIBRARY_DIR} crystal spec -v spec/")
    end
    success("Done spec")
  rescue e : Exception
    error(e.to_s)
  end
end
