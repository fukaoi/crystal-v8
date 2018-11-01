require "./defined"

class Build < LuckyCli::Task
  banner "Build C++, Crystal program files"
  @gn_env_dir : String
  @file_name : String

  def initialize
    return if ARGV != ["build"] && ARGV != ["full_build"]
    case ENV["LUCKY_ENV"]
    when "release"
      @gn_env_dir = GN_RELEASE_DIR
      @file_name = V8_RELEASR_RAPPER
    when "development"
      @gn_env_dir = GN_DEVELOPMENT_DIR
      @file_name = V8_DEVELOPMENT_RAPPER
    when "test"
      @gn_env_dir = GN_TEST_DIR
      @file_name = V8_TEST_RAPPER
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
    @env = ENV["LUCKY_ENV"]
  end

  def call
    cplus_build
    crystal_build
  end

  def crystal_build
    system("crystal build src/#{get_project_name}.cr -o bin/#{get_project_name}")
  end

  def cplus_build
    if self.@env == "test"
      system("cd #{V8_DIR};  g++ -I. -Iinclude  ../../src/#{@file_name}.cc -fPIC -o ../../bin/#{@file_name} -L#{@gn_env_dir}/obj/ -lv8_monolith -pthread -std=c++0x")
    else
      system("cd #{V8_DIR};  g++ -I. -Iinclude -c ../../src/#{@file_name}.cc -fPIC -o ../../bin/#{@file_name} -L#{@gn_env_dir}/obj/ -pthread -std=c++0x")
    end
  end
end

class FullBuild < Build
  banner "Build C++, Crystal program files and V8"

  def call
    system("cd ./#{V8_DIR}; ./tools/dev/v8gen.py ./#{self.@gn_env_dir}")
    system("cd ./#{V8_DIR}; gn args ./#{self.@gn_env_dir}")
    if self.@env == "test"
      system("cd ./#{V8_DIR}; ninja -C #{self.@gn_env_dir} v8_monolith")
      self.cplus_build
    else
      system("cd ./#{V8_DIR}; ninja -C #{self.@gn_env_dir}")
      system("cp -r #{V8_DIR}/out.gn/#{self.@gn_env_dir}/lib*.so ./#{LIBRARY_DIR}")
      self.cplus_build
      self.crystal_build
    end
  end
end

# ### test ####
# is_component_build = false
# is_debug = false
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = true
# v8_use_external_startup_data = false
