#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <libplatform/libplatform.h>
#include <v8.h>

using namespace std;
using namespace v8;

extern "C" bool init_icu(const char *external_file_path);
extern "C" void init();
extern "C" void destroy();
extern "C" const char* eval(const char *src);

const char *to_c_string(const String::Utf8Value &value);
