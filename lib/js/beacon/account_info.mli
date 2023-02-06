open Js_of_ocaml

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

val from_js : #Bindings.accountInfo Js.t -> t
