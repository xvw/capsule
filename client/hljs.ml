open Js_of_ocaml

type t = Bindings.Hljs.hljs Js.t

let get () : t = Js.Unsafe.global##.hljs

let mount () =
  let hljs = get () in
  let () = hljs##highlightAll in
  Lwt.return_unit
