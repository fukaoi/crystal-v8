TOOLS_DIR              = "./tools"
DEPOT_DIR              = "#{TOOLS_DIR}/depot_tools"
V8_DIR                 = "#{TOOLS_DIR}/v8"
LIBRARY_DIR            = "./lib"
GN_RELEASE_DIR         = "out.gn/x64.release"
GN_DEVELOPMENT_DIR     = "out.gn/x64.debug"
GN_TEST_DIR            = "out.gn/x64.release.sample"

V8_RELEASR_RAPPER      = "v8_glue"
V8_DEVELOPMENT_RAPPER  = "jslib"
V8_TEST_RAPPER         = "main"

def export_depot_tools
  system("export PATH=#{TOOLS_DIR}/depot_tools:$PATH")
end

def get_project_name
  # todo: extract shard.yml
  "glue-js"
end
export_depot_tools
