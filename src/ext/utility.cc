#include "utility.h"

inline static const char *ToCString(const String::Utf8Value &value)
{
  const char *val = *value ? *value : "<Failed string convert>";
  char *setval = new char[strlen(val) + 1];
  strcpy(setval, val);
  return (const char *)setval;
}
