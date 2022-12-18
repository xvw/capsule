open Js_of_ocaml

type t = {
    id : string
  ; sender_id : string
  ; version : string
  ; network : Network.t
  ; public_key : string
  ; scopes : Permission_scope.t list
}

val from_js : #Bindings.permissionResponse Js.t -> t
