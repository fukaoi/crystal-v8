#ifndef EXT_REQUIRE_
#define EXT_REQUIRE_

#include <string.h>
#include <assert.h>
#include "v8.h"
#include "libplatform/libplatform.h"
#include "utility.h"

using namespace v8;

class Require
{
private:

public:
  Require();
  static void Exec(const FunctionCallbackInfo<Value> &args);
  static MaybeLocal<String> ReadFile(Isolate *isolate, const char *name);
  static bool ExecuteString(Isolate *isolate, Local<String> source,
                     Local<Value> name, bool print_result,
                     bool report_exceptions);
  static void ReportException(Isolate *isolate, TryCatch *try_catch);
  ~Require();
};

#endif