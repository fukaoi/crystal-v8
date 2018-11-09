require "./defined"

class Clean < LuckyCli::Task
  banner "clean up bin/* and shared library"
  BIN_RM = "rm -r bin/*;rm -r lib/*.so;rm -r lib/*.o"

  def call
    unless system(BIN_RM)
      puts "Failed clean up"
    else
      puts "clean up"
    end
  end
end

class FullClean < LuckyCli::Task
  banner "clean up bin/* and v8/ and shared library"

  def call
    Clean.new.call
    unless system("rm -rf ./#{V8_DIR}")
      puts "Failed clean up"
    else
      puts "full clean up"
    end
  end
end
