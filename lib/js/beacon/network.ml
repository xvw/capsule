open Js_of_ocaml
open Core_js

type type_ = Tezos.Network.type_
type t = { name : string option; rpc_url : string option; type_ : type_ }

let from_js network =
  let open Option in
  let name = Js.to_string <$> from_undefinedable network##.name
  and rpc_url = Js.to_string <$> from_undefinedable network##.rpcUrl
  and type_ = network##._type |> Tezos.Network.from_string % Js.to_string in
  { name; rpc_url; type_ }

let to_js { name; rpc_url; type_ } =
  let open Undefinedable in
  object%js
    val name = Js.string <$> from_option name
    val rpcUrl = Js.string <$> from_option rpc_url
    val _type = type_ |> Js.string % Tezos.Network.to_string
  end
