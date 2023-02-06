open Js_of_ocaml

type t = { amount : string; timeframe : string }

val from_js : #Bindings.threshold Js.t -> t
