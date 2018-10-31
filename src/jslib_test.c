// gcc src/jslib.o -lstdc++ ext/libv8_libplatform.so ext/libv8_libbase.so ext/libicui18n.so ext/libicuuc.so ext/libv8.so  src/jslib_test.c -o src/jslib_test.o

#include <string.h>

void main() {
  jslib("1+1");
  // jslib("new Date()", "glue");
}