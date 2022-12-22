open Js_of_ocaml

type type_ = Tezos.Network.type_
type t = { name : string option; rpc_url : string option; type_ : type_ }

val from_js : #Bindings.network Js.t -> t
val to_js : t -> Bindings.network Js.t
