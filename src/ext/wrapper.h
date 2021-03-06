#ifndef EXT_WRAPPER_
#define EXT_WRAPPER_

#include <stdlib.h>
#include <string.h>
#include <iostream>
#include "libplatform/libplatform.h"
#include "v8.h"
#include "utility.cc"
#include "require.cc"

using namespace std;
using namespace v8;

extern "C" {
  void init_icu(const char *external_file_path);
  void init();
  void destroy();
  const char* eval(const char *src);
}

Local<Context> SetupCustomFunction();
#endif