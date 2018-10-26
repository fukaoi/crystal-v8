#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "include/v8.h"
#include "include/libplatform/libplatform.h"

int main(int argc, char* argv[]) {
  v8::V8::InitializeDefaultLocation(argv[0]);
}