#include "v8.h"
#include <string.h>

using namespace v8;

class Utility
{
public:
  static const char *ToCString(const String::Utf8Value &value);
};
