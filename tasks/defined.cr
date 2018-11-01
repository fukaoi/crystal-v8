TOOLS_DIR   = "tools"
DEPOT_DIR   = "#{TOOLS_DIR}/depot_tools"
V8_DIR      = "#{TOOLS_DIR}/v8"
LIBRARY_DIR = "lib"

GN_RELEASE_DIR     = "out.gn/x64.release"
GN_DEVELOPMENT_DIR = "out.gn/x64.debug"
GN_TEST_DIR        = "out.gn/x64.release.sample"

V8_RELEASR_RAPPER     = "v8_glue"
V8_DEVELOPMENT_RAPPER = "jslib"
V8_TEST_RAPPER        = "main"

def set_env
  ENV["PATH"] += ":#{ENV["PWD"]}/#{DEPOT_DIR}"
  ENV["LD_LIBRARY_PATH"] = "#{ENV["PWD"]}/#{LIBRARY_DIR}"
end

set_env

def get_project_name
  # todo: extract shard.yml
  "glue"
end
