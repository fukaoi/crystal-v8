require "lucky_cli"

class Spec < LuckyCli::Task
  banner "Spec all test and spec file select test"

  def call
    if ARGV.size > 0
      system("LD_LIBRARY_PATH=`pwd`/#{LIBRARY_DIR} crystal spec -v #{ARGV[0]}")
    else
      system("LD_LIBRARY_PATH=`pwd`/#{LIBRARY_DIR} crystal spec -v spec/")
    end
    puts "Done spec."
  end
end
