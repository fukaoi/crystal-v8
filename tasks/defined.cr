TOOLS_DIR   = "tools"
DEPOT_DIR   = "#{TOOLS_DIR}/depot_tools"
V8_DIR      = "#{TOOLS_DIR}/v8"
LIBRARY_DIR = "lib"

GN_RELEASE_DIR     = "out.gn/x64.release.sample"
GN_DEVELOPMENT_DIR = "out.gn/x64.release.sample"
GN_TEST_DIR       = "out.gn/x64.release.sample"


V8_RELEASR     = "v8_release"
V8_DEVELOPMENT = "v8_developemnt"
V8_TEST        = "v8_test"

def set_env
  ENV["PATH"] += ":#{ENV["PWD"]}/#{DEPOT_DIR}"
  ENV["LD_LIBRARY_PATH"] = "#{ENV["PWD"]}/#{LIBRARY_DIR}"
end

set_env

def get_target_main
  # todo: extract shard.yml
  "src/v8.cr"
end
