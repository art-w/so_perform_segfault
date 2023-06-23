let[@inline never] id x = x

module Stubs (I : Cstubs_inverted.INTERNAL) = struct
  include Ctypes

  let () =
    I.internal ~runtime_lock:false "mycamlbindings_toto"
      (void @-> returning void)
      (fun () ->
        let () =
          let open Effect.Deep in
          match_with
            (fun () -> id ())
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
