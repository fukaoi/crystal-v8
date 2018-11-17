#pragma once

#include <string.h>
#include "v8.h"

using namespace v8;

class Utility
{
public:
  static const char *ToCrystalString(const String::Utf8Value &value);
  static const char *ToCString(const String::Utf8Value &value);
};

inline const char *Utility::ToCrystalString(const String::Utf8Value &value)
{
  const char *val = *value ? *value : "<Failed string convert>";
  char *setval = new char[strlen(val) + 1];
  strcpy(setval, val);
  return (const char *)setval;
}

inline const char *Utility::ToCString(const String::Utf8Value& value) {
  return *value ? *value : "<string conversion failed>";
}
