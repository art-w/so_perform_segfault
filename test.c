#include <stdio.h>
#include <stdlib.h>
#include "mycaml.h"

int main(int argc, char *argv[]) {
  caml_startup(argv);
  printf("--- before the call\n");
  mycamlbindings_toto();
  printf("--- after the call\n");
  caml_shutdown();
  printf("--- exit\n");
  return 1;
}
