#include <stdio.h>
#include <stdlib.h>
#include <caml/callback.h>

static value my_function;

value register_my_function(value v) {
  CAMLparam1(v);
  my_function = v;
  caml_register_global_root(&my_function);
  CAMLreturn (Val_unit);
}

void call_my_function(void) {
  CAMLparam0();
  value result = caml_callback(my_function, Val_unit);
  CAMLdrop;
  return;
}

int main(int argc, char *argv[]) {
  printf("--- startup\n");
  caml_startup(argv);
  printf("--- before the call\n");
  call_my_function();
  printf("--- after the call\n");
  caml_shutdown();
  printf("--- exit\n");
  return 0;
}
