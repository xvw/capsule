open Js_of_ocaml

type t = {
    id : string
  ; sender_id : string
  ; version : string
  ; network : Network.t
  ; public_key : string
  ; scopes : Permission_scope.t list
}

let from_js response =
  let id = Js.to_string response##.id
  and sender_id = Js.to_string response##.senderId
  and version = Js.to_string response##.version
  and network = Network.from_js response##.network
  and public_key = Js.to_string response##.publicKey
  and scopes = Permission_scope.from_js_array response##.scopes in
  { id; sender_id; version; network; public_key; scopes }
