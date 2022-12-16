open Js_of_ocaml

let clear_node node = node##.innerHTML := Js.string ""
