module Aliases = Aliases
module Interfaces = Interfaces
module Option = Option_stubs
module Nullable = Nullable_stubs
module Undefinedable = Undefinedable_stubs

type +'a or_null = 'a Aliases.or_null
type +'a or_undefined = 'a Aliases.or_undefined
type +'a promise = 'a Promise.t

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
