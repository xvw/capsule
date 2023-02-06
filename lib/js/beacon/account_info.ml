open Js_of_ocaml
open Core_js

type t = {
    identifier : string
  ; address : string
  ; public_key : string
  ; scopes : Permission_scope.t list
  ; connected_at : int
  ; network : Network.t
  ; sender_id : string
  ; threshold : Threshold.t option
}

let from_js account_info =
  let open Option in
  let identifier = Js.to_string account_info##.accountIdentifier
  and address = Js.to_string account_info##.address
  and public_key = Js.to_string account_info##.publicKey
  and scopes = Permission_scope.from_js_array account_info##.scopes
  and connected_at = account_info##.connectedAt
  and network = Network.from_js account_info##.network
  and sender_id = Js.to_string account_info##.senderId
  and threshold =
    Threshold.from_js <$> from_undefinedable account_info##.threshold
  in
  {
    identifier
  ; address
  ; public_key
  ; scopes
  ; connected_at
  ; network
  ; sender_id
  ; threshold
  }
