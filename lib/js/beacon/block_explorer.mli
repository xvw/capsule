open Js_of_ocaml

type t = Bindings.blockExplorer Js.t

val get_address_link : t -> string -> Network.t -> string Lwt.t
val get_transaction_link : t -> string -> Network.t -> string Lwt.t
