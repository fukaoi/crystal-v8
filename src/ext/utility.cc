#include "utility.h"

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
