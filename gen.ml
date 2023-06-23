let generate dirname =
  let prefix = "mycaml" in
  let path basename = Filename.concat dirname basename in
  let ml_fd = open_out (path "mycaml_generated.ml") in
  let c_fd = open_out (path "mycaml.c") in
  let h_fd = open_out (path "mycaml.h") in
  let stubs = (module Mycamlbindings.Stubs : Cstubs_inverted.BINDINGS) in
  let writeln fd s = output_string fd (s ^ "\n") in
  (* Generate the ML module that links in the generated C. *)
  Cstubs_inverted.write_ml (Format.formatter_of_out_channel ml_fd) ~prefix stubs;

  (* Generate the C source file that exports OCaml functions. *)
  Format.fprintf
    (Format.formatter_of_out_channel c_fd)
    "#include \"mycaml.h\"@\n%a"
    (Cstubs_inverted.write_c ~prefix)
    stubs;

  (* Generate the C header file that exports OCaml functions. *)
  writeln h_fd "#pragma once";
  writeln h_fd "#include <stdbool.h>";
  writeln h_fd "#include <stdint.h>";
  writeln h_fd "void caml_startup(char *argv[]);";
  writeln h_fd "void caml_shutdown();";

  Cstubs_inverted.write_c_header
    (Format.formatter_of_out_channel h_fd)
    ~prefix stubs;

  close_out h_fd;
  close_out c_fd;
  close_out ml_fd

let () = generate Sys.argv.(1)
