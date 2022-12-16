open Js_of_ocaml

type +'a promise = 'a Promise.t

exception Promise_resolve_error of Promise.error

let promise_to_lwt promise =
  let handler, resolver = Lwt.wait () in
  let is_done value =
    let () = Lwt.wakeup_later resolver value in
    Promise.return ()
  and is_rejected reason =
    let () = Lwt.wakeup_later_exn resolver (Promise_resolve_error reason) in
    Promise.return ()
  in
  let _ = Promise.then_ ~fulfilled:is_done ~rejected:is_rejected promise in
  handler

let lwt_to_promise promise =
  Promise.make (fun ~resolve ~reject ->
      let reject = function
        | Promise_resolve_error err -> reject err
        | e -> reject (Obj.magic e : Promise.error)
      in
      Lwt.on_any promise resolve reject)

let list_to_js_array f list =
  let array = new%js Js.array_empty in
  let () =
    List.fold_left
      (fun () x ->
        let _ = array##push (f x) in
        ())
      () list
  in
  array

let js_array_to_list f array =
  let length = array##.length in
  List.init length (fun i ->
      match Js.array_get array i |> Js.Optdef.to_option with
      | Some x -> f x
      | None -> assert false)
