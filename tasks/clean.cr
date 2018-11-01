require "./defined"

class Clean < LuckyCli::Task
  banner "clean up bin/*"
  BIN_RM = "rm -rf bin/*"

  def call
    unless system(BIN_RM)
      puts "Failed clean up"
    else
      puts "clean up"
    end
  end
end

class FullClean < LuckyCli::Task
  banner "clean up bin/* and v8/"

  def call
    Clean.new.call
    unless system("rm -rf ./#{V8_DIR}")
      puts "Failed clean up"
    else
      puts "full clean up"
    end
  end
end
