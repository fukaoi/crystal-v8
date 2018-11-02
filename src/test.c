// gcc lib/glue.o -lstdc++ lib/libv8_libplatform.so lib/libv8_libbase.so lib/libicui18n.so lib/libicuuc.so lib/libv8.so  src/test.c -o bin/test.o
#include <string.h>

void main() {
  init();
  run("1+1");
  finalyze();
}