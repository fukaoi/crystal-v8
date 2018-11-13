require "yaml"

TOOLS_DIR   = "tools"
DEPOT_DIR   = "#{TOOLS_DIR}/depot_tools"
V8_DIR      = "#{TOOLS_DIR}/v8"
LIBRARY_DIR = "lib"

GN_RELEASE_DIR     = "out.gn/x64.debug"
GN_DEVELOPMENT_DIR = "out.gn/x64.debug"
GN_TEST_DIR        = "out.gn/x64.debug"

V8_RELEASE     = "v8_release"
V8_DEVELOPMENT = "v8_developemnt"
V8_TEST        = "v8_test"

def set_env
  ENV["PATH"] += ":#{ENV["PWD"]}/#{DEPOT_DIR}"
  ENV["LD_LIBRARY_PATH"] = "#{ENV["PWD"]}/#{LIBRARY_DIR}"
end

set_env

def get_target_main
  yaml = File.open("shard.yml") do |file|
    YAML.parse(file)
  end
  yaml["targets"]["v8"]["main"]
end

def get_target_lib
  yaml = File.open("shard.yml") do |file|
    YAML.parse(file)
  end
  yaml["targets"]["v8"]["lib"]
end

def get_v8_shared_object
    %w(
      libicui18n.so
      libicuuc.so
      libv8_libbase.so
      libv8_libplatform.so
      libv8.so
    )
end
