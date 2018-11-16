require "./defined"

class Clean < LuckyCli::Task
  banner "clean up bin/*"
  BIN_RM = "rm -r bin/* && rm -r libv8/*"

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
    unless system("rm -r ./#{V8_DIR} && rm -r tools/.gclient* && rm -r tools/.cipd")
      puts "Failed clean up"
    else
      puts "full clean up"
    end
  end
end
