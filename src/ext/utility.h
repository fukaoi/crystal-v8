#ifndef EXT_UTILITY_
#define EXT_UTILITY_

#include <string.h>
#include "v8.h"

using namespace v8;

class Utility
{
public:
  static const char *ToCrystalString(const String::Utf8Value &value);
  static const char *ToCString(const String::Utf8Value &value);
};

#endif