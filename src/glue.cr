require "file_utils"

#### gn config ####
# is_component_build = true
# is_debug = false
# target_cpu = "x64"
# use_custom_libcxx = false
# v8_monolithic = false
# v8_use_external_startup_data = false
# v8_static_library = true

@[Link(ldflags: " \
  #{__DIR__}/jslib.o -lstdc++ \
  #{__DIR__}/../ext/libicui18n.so \
  #{__DIR__}/../ext/libv8_libplatform.so \
  #{__DIR__}/../ext/libicuuc.so \
  #{__DIR__}/../ext/libv8_libbase.so \
  #{__DIR__}/../ext/libv8.so"
)]
lib Say
  fun jslib(jscode : LibC::Char*) : Void
end

#!pp LibC.strlen("test")
#!pp LibC.strlen("てすとだお")

#Say.jslib("new Date()")
# Say.jslib("const a = 10;let b = 10;a + b;")
Say.jslib("const fn = function(a){return a * 999};fn(10)")
Say.jslib("const fn = (a)=> {return a * 555};fn(10)")


