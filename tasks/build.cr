require "./defined"
require "file_utils"

class Build < LuckyCli::Task
  banner "Build C++, Crystal program files"

  @file_name = ""
  @cplus_option = ""
  @crytal_option = ""
  @env = ""

  def initialize
    return if ARGV != ["build"] && ARGV != ["v8_build"]
    case ENV["LUCKY_ENV"]
    when "release"
      @file_name = V8_RELEASE
      @cplus_option = ""
      @crytal_option = ""
    when "development"
      @file_name = V8_DEVELOPMENT
      @cplus_option = ""
      @crytal_option = ""
    when "test"
      @file_name = V8_TEST
      @cplus_option = "-g -Wall"
      @crytal_option = "-d"
    end
    @env = ENV["LUCKY_ENV"]
  end

  def call
    mkdir_libv8
    cplus_build
    crystal_build
    copy_libv8
    success("Build done")
  rescue e : Exception
    error(e.to_s)
  end

  private def crystal_build
    raise Exception.new("Crystal build failed") unless system(
      <<-CMD
        crystal build \
        #{@crytal_option} \
        #{ENV["PWD"]}/src/#{get_target_main} \
        -o bin/#{@file_name}
      CMD
    )
  end

  private def cplus_build
    cmd =
    <<-CMD
      cd #{V8_DIR}; \
      g++ -I. -Iinclude \
      ../../src/ext/*.cc \
      -o ../../#{LIBRARY_DIR}/libv8_wrapper.so \
      -L#{get_gn_dir}/obj/ \
      -fPIC \
      -pthread \
      -std=c++0x \
      -shared #{@cplus_option}
    CMD
    debug(cmd) if @env == "test"
    raise Exception.new("C++ build failed") unless system(cmd)
  end

  private def mkdir_libv8
    FileUtils.mkdir(LIBRARY_DIR) unless Dir.exists?(LIBRARY_DIR)
  end

  private def copy_libv8
    get_v8_shared_object.each { |so| FileUtils.cp("#{V8_DIR}/#{get_gn_dir}/#{so}", "#{LIBRARY_DIR}/#{so}") }
  end
end

class V8Build < LuckyCli::Task
  banner "Build V8"

  def initialize
    set_env
  end

  def call
    res_flag = true
    res_flag & system("cd ./#{V8_DIR}; ./tools/dev/v8gen.py ./#{get_gn_dir}")
    res_flag & system("cd ./#{V8_DIR}; gn gen ./#res_flag = {get_gn_dir} #{create_gn_args}")
    res_flag & system("cd ./#{V8_DIR}; ninja -C #{get_gn_dir}")

    if res_flag
      success("V8 build done")
    else
      error("V8 build failed")
    end
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

  private def set_env
    ENV["PATH"] += ":#{ENV["PWD"]}/#{DEPOT_DIR}"
    ENV["LD_LIBRARY_PATH"] = "#{ENV["PWD"]}/#{LIBRARY_DIR}"
  end
end
