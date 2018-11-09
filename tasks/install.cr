require "./defined"

class Install < LuckyCli::Task
  banner "Install v8,shards,etc."

  def call
    unless Dir.exists?("#{DEPOT_DIR}")
      system("cd ./#{TOOLS_DIR};git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git")
    end
    system("cd #{TOOLS_DIR};fetch v8")
    system("cd #{V8_DIR};gclient sync")
    system("shards check || shards update;shards prune")
  end
end
