open Js_of_ocaml

type t = {
    name : string option
  ; rpc_url : string option
  ; type_ : Network_type.t
}

val from_js : #Bindings.network Js.t -> t
val to_js : t -> Bindings.network Js.t
