require "./defined"
require "file_utils"

class Build < LuckyCli::Task
  banner "Build C++, Crystal program files"
  @gn_env_dir : String
  @file_name : String
  @cplus_option : String
  @crytal_option : String

  @need_libs =
    %w(
      libicui18n.so
      libicuuc.so
      libv8_libbase.so
      libv8_libplatform.so
      libv8.so
    )

  def initialize
    return if ARGV != ["build"] && ARGV != ["full_build"]

    case ENV["LUCKY_ENV"]
    when "release"
      @gn_env_dir = GN_RELEASE_DIR
      @file_name = V8_RELEASR
      @cplus_option = ""
      @crytal_option = ""
    when "development"
      @gn_env_dir = GN_DEVELOPMENT_DIR
      @file_name = V8_DEVELOPMENT
      @cplus_option = ""
      @crytal_option = ""
    when "test"
      @gn_env_dir = GN_TEST_DIR
      @file_name = V8_TEST
      @cplus_option = "-g"
      @crytal_option = "-d"
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
    @need_libs.each { |so| FileUtils.cp("#{V8_DIR}/#{@gn_env_dir}/#{so}", "lib/#{so}") }
    if system(
         "crystal build #{@crytal_option} #{ENV["PWD"]}/src/#{get_target_main} \
       -o bin/#{@file_name}"
       )
      system("chmod 755 bin/#{@file_name}")
    end
  end

  def cplus_build
    system(
      "cd #{V8_DIR}; \
        g++ -I. -Iinclude \
        -c ../../src/#{get_target_lib} \
        -o ../../lib/libv8_wrapper.so \
        -L#{@gn_env_dir}/obj/ -fPIC -pthread -std=c++0x -shared #{@cplus_option}"
    )
  end
end

class FullBuild < Build
  banner "Build C++, Crystal program files and V8"

  def call
    system("cd ./#{V8_DIR}; ./tools/dev/v8gen.py ./#{self.@gn_env_dir}")
    system("cd ./#{V8_DIR}; gn gen ./#{self.@gn_env_dir} #{create_gn_args}")
    system("cd ./#{V8_DIR}; ninja -C #{self.@gn_env_dir}")
    self.cplus_build
    puts "full_build done."
  end

  private def create_gn_args
    <<-ARGS
    --args='is_debug=true \
            target_cpu="x64" \
            v8_static_library=true \
            is_component_build=true \
            is_debug=true \
            target_cpu="x64"\
            use_custom_libcxx=false \
            v8_monolithic=false \
            v8_use_external_startup_data=false'
    ARGS
  end
end

# ### test ####
# cc_wrapper = "ccache"
# v8_static_library = true
# is_component_build = true
# is_debug = true
# target_cpu = "x64"

# ### development ####
# cc_wrapper = "ccache"
# v8_static_library = true
# is_component_build = true
# is_debug = true
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = false
# v8_use_external_startup_data = false
