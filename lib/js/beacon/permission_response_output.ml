open Js_of_ocaml

type t = {
    response : Permission_response.t
  ; account_info : Account_info.t
  ; address : string
}

let from_js response =
  let response = Permission_response.from_js response
  and account_info = Account_info.from_js response##.accountInfo
  and address = Js.to_string response##.address in
  { response; account_info; address }
