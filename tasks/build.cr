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
      @file_name = V8_RELEASR
    when "development"
      @gn_env_dir = GN_DEVELOPMENT_DIR
      @file_name = V8_DEVELOPMENT
    when "test"
      @gn_env_dir = GN_TEST_DIR
      @file_name = V8_TEST
    else
      raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
    end
    @env = ENV["LUCKY_ENV"]
  end

  def call
    cplus_build
    crystal_build
    puts "build done."
  end

  def crystal_build
    system("crystal build #{ENV["PWD"]}/#{get_target_main} -o bin/#{@file_name}")
    system("chmod 755 bin/#{@file_name}")
  end

  def cplus_build
      system("cd #{V8_DIR};
      g++ -I. -Iinclude \
      -c ../../src/wrapper.cc \
      -o ../../bin/#{@file_name} \
      -L#{@gn_env_dir}/obj/ -lv8_monolith \
      -fPIC -pthread -std=c++0x -g")
  end
end

class FullBuild < Build
  banner "Build C++, Crystal program files and V8"

  def call
    system("cd ./#{V8_DIR}; ./tools/dev/v8gen.py ./#{self.@gn_env_dir}")
    system("cd ./#{V8_DIR}; gn args ./#{self.@gn_env_dir}")
    system("cd ./#{V8_DIR}; ninja -C #{self.@gn_env_dir} v8_monolith")
    self.cplus_build
    puts "full_build done."
  end
end

# ### test ####
# is_component_build = false
# is_debug = true
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = true
# v8_use_external_startup_data = false

#### development ####
# v8_static_library = true
# is_component_build = true
# is_debug = true
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = false
# v8_use_external_startup_data = false
