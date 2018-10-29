#### gn config ####
# is_component_build = true
# is_debug = false
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = false
# v8_use_external_startup_data = false
# v8_static_library = true

@[Link(ldflags: "#{__DIR__}/jslib.o  -lstdc++ #{__DIR__}/libicui18n.so #{__DIR__}/libv8_libplatform.so  #{__DIR__}/libicuuc.so #{__DIR__}/libv8_libbase.so  #{__DIR__}/libv8.so")]

lib Say
  fun jslib(jscode : LibC::Char*) : Void
end

Say.jslib("new Date()")
