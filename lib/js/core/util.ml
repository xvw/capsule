open Js_of_ocaml

type hidden = Hidden : 'a -> hidden

let hide x = Hidden x
let id x = x
let const x _ = x
let flip f x y = f y x
let ( % ) f g x = f (g x)

type +'a promise = 'a Aliases.promise

exception Promise_resolve_error of Promise.error

let as_lwt js_promise =
  let handler, resolver = Lwt.wait () in
  let fulfilled value =
    let () = Lwt.wakeup_later resolver value in
    Promise.return ()
  and rejected reason =
    let () = Lwt.wakeup_later_exn resolver (Promise_resolve_error reason) in
    Promise.return ()
  in
  let _ = Promise.then_ ~fulfilled ~rejected js_promise in
  handler

let as_promise lwt_promise =
  Promise.make (fun ~resolve ~reject ->
      let reject = function
        | Promise_resolve_error err -> reject err
        | e -> reject (Obj.magic e : Promise.error)
      in
      Lwt.on_any lwt_promise resolve reject)

let as_js_array f arr =
  let array = new%js Js.array_empty in
  let () =
    Array.fold_left
      (fun () x ->
        let _ = array##push (f x) in
        ())
      () arr
  in
  array

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

let as_array f array =
  let length = array##.length in
  Array.init length (fun i ->
      match Js.array_get array i |> Js.Optdef.to_option with
      | Some x -> f x
      | None -> assert false)
