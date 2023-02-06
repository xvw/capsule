open Js_of_ocaml
open Core_js

type t = Bindings.blockExplorer Js.t

let get_address_link explorer address network =
  let addr = Js.string address and net = Network.to_js network in
  explorer##getAddressLink addr net |> as_lwt |> Lwt.map Js.to_string

let get_transaction_link explorer transaction_id network =
  let t_id = Js.string transaction_id and net = Network.to_js network in
  explorer##getTransactionLink t_id net |> as_lwt |> Lwt.map Js.to_string
