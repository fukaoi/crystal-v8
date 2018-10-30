// gcc src/jslib.o -lstdc++ ext/libv8_libplatform.so ext/libv8_libbase.so ext/libicui18n.so ext/libicuuc.so ext/libv8.so  src/jslib_test.c

#include <string.h>

void main() {
  jslib("new Date()", "glue");
  jslib("new Date()", "glue");
}