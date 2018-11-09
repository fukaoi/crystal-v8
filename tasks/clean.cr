require "./defined"

class Clean < LuckyCli::Task
  banner "clean up bin/* and shared library"
  BIN_RM = "rm -r bin/*"

  def call
    get_v8_shared_object.each { |so| FileUtils.rm(so) }
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
    unless system("rm -r ./#{V8_DIR} && rm -r tools/.gclient* && rm -r tools/.cipd")
      puts "Failed clean up"
    else
      puts "full clean up"
    end
  end
end
