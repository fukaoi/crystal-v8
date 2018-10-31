class Install < LuckyCli::Task
  banner "Install v8,shards,etc."
  TOOLS_DIR = "./tools"

  def call
    Dir.mkdir(TOOLS_DIR) unless Dir.exists?(TOOLS_DIR)
    unless Dir.exists?("#{TOOLS_DIR}/depot_tools")
      system("cd #{TOOLS_DIR};git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git");
    end
    system("export PATH=$PWD/depot_tools:$PATH")
    system("cd #{TOOLS_DIR};fetch v8")
    system("cd v8; gclient sync")
    system("shards check || shards update;shards prune")
  end
end
