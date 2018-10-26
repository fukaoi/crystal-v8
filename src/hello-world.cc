#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "v8.h"

int main(int argc, char* argv[]) {
  v8::V8::InitializeDefaultLocation(argv[0]);
}