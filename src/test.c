#include <string.h>
#include "glue.h"

void main() {
  init();
  run("1+1");
  run("1+1");
  run("1+1");
  run("1+1");
  run("new Date()");
  finalyze();
}