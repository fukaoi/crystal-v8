#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <libplatform/libplatform.h>
#include <v8.h>

extern "C" bool init_icu(const char *external_file_path);
extern "C" void init();
extern "C" void destroy();
extern "C" void eval(const char *src);