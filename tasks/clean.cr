require "./defined"

class Clean < LuckyCli::Task
  banner "clean up bin/*"
  BIN_RM = "rm -rf bin/* && rm -rf libv8/*"

  def call
    unless system(BIN_RM)
      error("Failed clean up")
    else
      success("Clean up")
    end
  end
end

class FullClean < LuckyCli::Task
  banner "clean up bin/* and v8/"

  def call
    Clean.new.call
    unless system("rm -rf ./#{V8_DIR} && rm -rf tools/.gclient* && rm -rf tools/.cipd")
      error("Failed clean up")
    else
      success("full clean up")
    end
  end
end
