open Js_of_ocaml

type type_ = Tezos_js.Network.type_
type t = { name : string option; rpc_url : string option; type_ : type_ }

val from_js : #Bindings.network Js.t -> t
val to_js : t -> Bindings.network Js.t
val from_tezos_network : Tezos_js.Network.t -> t
