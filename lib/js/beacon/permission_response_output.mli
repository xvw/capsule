open Js_of_ocaml

type t = {
    response : Permission_response.t
  ; account_info : Account_info.t
  ; address : string
}

val from_js : #Bindings.permissionResponseOutput Js.t -> t
