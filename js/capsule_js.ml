open Js_of_ocaml
open Nightmare_js

module Hljs = struct
  let get () = Js.Unsafe.global##.hljs

  let mount () =
    let hljs = get () in
    let () = hljs##highlightAll in
    Lwt.return_unit
  ;;
end

let () = Suspension.allow ()

let () =
  Js.export
    "capsule_hljs"
    (object%js
       method run = Hljs.mount ()
    end)
;;
