let rec fib n = if n <= 1 then n else fib (n - 1) + fib (n - 2)

module Stubs (I : Cstubs_inverted.INTERNAL) = struct
  include Ctypes

  let () =
    I.internal ~runtime_lock:false "mycamlbindings_toto"
      (void @-> returning void)
      (fun () ->
        let () =
          let open Effect.Deep in
          match_with
            (fun () -> ignore (fib 5))
            ()
            {
              retc = (fun x -> x);
              exnc = (fun e -> raise e);
              effc = (fun (type a) (_ : a Effect.t) -> None);
            };
          ()
        in
        Format.printf "and out!@.")
end
