require "./defined"
require "file_utils"

class Build < LuckyCli::Task
  banner "Build C++, Crystal program files"

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
    if system(
      <<-CMD
        crystal build #{@crytal_option} \
        #{ENV["PWD"]}/src/#{get_target_main} \
        -o bin/#{@file_name}
      CMD
      )
      system("chmod 755 bin/#{@file_name}")
    end
  end

  def cplus_build
    system(
      <<-CMD
        g++ -I. -I#{LIBRARY_DIR}/include \
        -c src/ext/#{get_target_lib} \
        -o src/ext/libv8_bridge.so \
        -lv8pp \
        -L#{LIBRARY_DIR}/lib \
        -Lsrc/ext \
        -fPIC \
        -pthread \
        -std=c++0x \
        -shared #{@cplus_option}
      CMD
    )
    # copy_libv8
  end

  private def copy_libv8
    FileUtils.mkdir(LIBRARY_DIR) unless Dir.exists?(LIBRARY_DIR)
    get_v8_shared_object.each { |so| FileUtils.cp("#{V8_DIR}/#{get_gn_dir}/#{so}", "#{LIBRARY_DIR}/#{so}") }
  end
end

class V8Build < LuckyCli::Task
  banner "Build V8"

  def initialize
    set_env
  end

  def call
    system("cd ./#{V8_DIR}; ./tools/dev/v8gen.py ./#{get_gn_dir}")
    system("cd ./#{V8_DIR}; gn gen ./#{get_gn_dir} #{create_gn_args}")
    system("cd ./#{V8_DIR}; ninja -C #{get_gn_dir}")
    puts "v8 build done."
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
