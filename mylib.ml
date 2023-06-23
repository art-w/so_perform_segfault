type _ Effect.t += Yield : unit Effect.t

let my_function () =
  Effect.Deep.match_with
    (fun () -> Effect.perform Yield)
    ()
    {
      retc = (fun x -> x);
      exnc = (fun e -> raise e);
      effc =
        (fun (type a) (e : a Effect.t) ->
          match e with
          | Yield ->
              Some
                (fun (k : (a, _) Effect.Deep.continuation) ->
                  Effect.Deep.continue k ())
          | _ -> None);
    }

external register_my_function : 'a -> unit = "register_my_function"

let () = register_my_function my_function
