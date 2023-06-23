module Stubs (I : Cstubs_inverted.INTERNAL) = struct
  include Ctypes

  type _ Effect.t += Yield : int -> unit Effect.t

  let () =
    I.internal ~runtime_lock:false "mycamlbindings_toto"
      (void @-> returning void)
      (fun () ->
        let () =
          (* Eio_posix.run @@ fun _env -> Format.printf "(test) coucou@." *)
          let open Effect.Deep in
          match_with
            (fun () -> Effect.perform (Yield 1))
            ()
            {
              retc = (fun x -> x);
              exnc = (fun e -> raise e);
              effc =
                (fun (type a) (e : a Effect.t) ->
                  match e with
                  | Yield x ->
                      Some
                        (fun (k : (a, _) continuation) ->
                          Format.printf "yield %i@." x;
                          continue k ())
                  | _ -> None);
            };
          ()
        in

        Format.printf "and out!@.";

        ())
end
