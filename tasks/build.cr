require "./defined"

class Build < LuckyCli::Task
  banner "Build C++, Crystal program files"
  @gn_env_dir   : String
  @file_name    : String
  @cplus_option : String

  def initialize
    return if ARGV == ["--help"]
    case ENV["LUCKY_ENV"]
    when "release"
      @gn_env_dir   = GN_RELEASE_DIR
      @file_name    = V8_RELEASR_RAPPER
      @cplus_option = "-c"
    when "development"
      @gn_env_dir = GN_DEVELOPMENT_DIR
      @file_name  = V8_DEVELOPMENT_RAPPER
      @cplus_option = "-c"
    when "test"
      @gn_env_dir = GN_TEST_DIR
      @file_name  = V8_TEST_RAPPER
      @cplus_option = "-lv8_monolith"
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
    @env = ENV["LUCKY_ENV"]
  end

  def call
    system("export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:#{LIBRARY_DIR}")
    system("cp -r v8/out.gn/#{@gn_env_dir}/lib*.so #{LIBRARY_DIR}")
    cplus_build
    crystal_build
  end


  def crystal_build
    system("crystal build src/#{get_project_name}.cr -o bin/#{get_project_name}")
  end

  def cplus_build
    system("#{V8_DIR};  g++ -I. -Iinclude  ../src/#{@file_name}.cc -fPIC -o ../bin/#{@file_name} -L#{@gn_env_dir}/obj/ -pthread -std=c++0x")
  end
end

class FullBuild < LuckyCli::Task
  banner "Build C++, Crystal program files and V8"

  def call
    obj = Build.new
    obj.call
    system("cd #{V8_DIR}; ./tools/dev/v8gen.py ./#{obj.@gn_env_dir}")
    system("cd #{V8_DIR}; gn args ./#{obj.@gn_env_dir}")
    if obj.@env == "test"
      system("cd #{V8_DIR}; ninja -C #{obj.@gn_env_dir} v8_monolith")
    else
      system("cd #{V8_DIR}; ninja -C #{obj.@gn_env_dir}")
    end
  end
end
