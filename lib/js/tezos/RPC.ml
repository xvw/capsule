module Directory = struct
  open Path

  let get_chain () = ~/:chain_id
  let get_block () = ~:get_chain /: block_id
  let get_context () = ~:get_block / "context"
  let get_contract () = ~:get_context /: contract_id
  let get_balance () = ~:get_contract / "balance"
end

open Core_js

let make_fetch entrypoint url =
  match Entrypoint.method_of entrypoint with
  | `GET -> Fetch.get url
  | `POST -> Fetch.post url
  | `PATCH -> Fetch.patch url
  | `DELETE -> Fetch.delete url

let make_call ~network ~entrypoint =
  let entrypoint = entrypoint () in
  Entrypoint.sprintf_with
    (fun path ->
      let url = Network.base_path network ^ "/" ^ path in
      let rpc_encoding = Entrypoint.encoding_of entrypoint in
      let open Lwt.Syntax in
      let* response = make_fetch entrypoint url in
      let+ json_txt = Fetch.Response.text response in
      json_txt
      |> Data_encoding.Json.from_string
      |> Result.map @@ Data_encoding.Json.destruct rpc_encoding)
    entrypoint

let make_call_head ~network ~entrypoint =
  make_call ~network ~entrypoint Chain_id.main Block_id.head

let get_balance () = Entrypoint.get ~path:Directory.get_balance Data_encoding.z
