class Clean < LuckyCli::Task
  banner "clean up bin/*"

  def call
    unless system("rm -rf bin/*")
      puts "Failed clean up"
    else
      puts "clean up"
    end
  end
end

class FullClean < LuckyCli::Task
  banner "clean up bin/* and v8/"

  def call
    unless system("rm -rf bin/*;rm -rf v8/")
      puts "Failed clean up"
    else
      puts "clean up"
    end
  end
end
