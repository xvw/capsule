open Js_of_ocaml
open Core_js

type t = {
    name : string option
  ; rpc_url : string option
  ; type_ : Network_type.t
}

let from_js network =
  let open Undefinedable in
  let name =
    let+ name = network##.name in
    Js.to_string name
  and rpc_url =
    let+ url = network##.rpcUrl in
    Js.to_string url
  and type_ = network##._type |> Js.to_string |> Network_type.from_string in
  { name = to_option name; rpc_url = to_option rpc_url; type_ }

let to_js { name; rpc_url; type_ } =
  let open Undefinedable in
  object%js
    val name = Js.string <$> from_option name
    val rpcUrl = Js.string <$> from_option rpc_url
    val _type = type_ |> Network_type.to_string |> Js.string
  end
