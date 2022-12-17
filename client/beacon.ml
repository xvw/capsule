open Js_of_ocaml

module MessageType = struct
  type t =
    | Acknowledge
    | BroadcastRequest
    | BroadcastResponse
    | Disconnect
    | Error
    | OperationRequest
    | OperationResponse
    | PermissionRequest
    | PermissionResponse
    | SignPayloadRequest
    | SignPayloadResponse

  let to_string = function
    | Acknowledge -> "acknowledge"
    | BroadcastRequest -> "broadcast_request"
    | BroadcastResponse -> "broadcast_response"
    | Disconnect -> "disconnect"
    | Error -> "error"
    | OperationRequest -> "operation_request"
    | OperationResponse -> "operation_response"
    | PermissionRequest -> "permission_request"
    | PermissionResponse -> "permission_response"
    | SignPayloadRequest -> "sign_payload_request"
    | SignPayloadResponse -> "sign_payload_response"

  let from_string str =
    match String.(trim (lowercase_ascii str)) with
    | "acknowledge" -> Acknowledge
    | "broadcast_request" -> BroadcastRequest
    | "broadcast_response" -> BroadcastResponse
    | "disconnect" -> Disconnect
    | "error" -> Error
    | "operation_request" -> OperationRequest
    | "operation_response" -> OperationResponse
    | "permission_request" -> PermissionRequest
    | "permission_response" -> PermissionResponse
    | "sign_payload_request" -> SignPayloadRequest
    | "sign_payload_response" -> SignPayloadResponse
    | _ -> Error
end

module NetworkType = struct
  type t =
    | CUSTOM
    | DELPHINET
    | EDONET
    | FLORENCENET
    | GRANADANET
    | HANGZHOUNET
    | ITHACANET
    | JAKARTANET
    | KATHMANDUNET
    | DAILYNET
    | MONDAYNET
    | GHOSTNET
    | MAINNET

  let to_string = function
    | CUSTOM -> "custom"
    | DELPHINET -> "delphinet"
    | EDONET -> "edonet"
    | FLORENCENET -> "florencenet"
    | GRANADANET -> "granadanet"
    | HANGZHOUNET -> "hangzhounet"
    | ITHACANET -> "ithacanet"
    | JAKARTANET -> "jakartanet"
    | KATHMANDUNET -> "kathmandunet"
    | DAILYNET -> "dailynet"
    | MONDAYNET -> "mondaynet"
    | GHOSTNET -> "ghostnet"
    | MAINNET -> "mainnet"

  let from_string str =
    match String.(trim (lowercase_ascii str)) with
    | "delphinet" -> DELPHINET
    | "edonet" -> EDONET
    | "florencenet" -> FLORENCENET
    | "granadanet" -> GRANADANET
    | "hangzhounet" -> HANGZHOUNET
    | "ithacanet" -> ITHACANET
    | "jakartanet" -> JAKARTANET
    | "kathmandunet" -> KATHMANDUNET
    | "dailynet" -> DAILYNET
    | "mondaynet" -> MONDAYNET
    | "ghostnet" -> GHOSTNET
    | "mainnet" -> MAINNET
    | _ -> CUSTOM
end

module PermissionScope = struct
  type t = ENCRYPT | OPERATION_REQUEST | SIGN | THRESHOLD

  let to_string = function
    | ENCRYPT -> "encrypt"
    | OPERATION_REQUEST -> "operation_request"
    | SIGN -> "sign"
    | THRESHOLD -> "threshold"

  let from_string str =
    match String.(trim (lowercase_ascii str)) with
    | "encrypt" -> Some ENCRYPT
    | "operation_request" -> Some OPERATION_REQUEST
    | "sign" -> Some SIGN
    | "threshold" -> Some THRESHOLD
    | _ -> None

  let from_js_array scopes =
    Util.js_array_to_list
      (fun x -> x |> Js.to_string |> from_string |> Option.to_list)
      scopes
    |> List.flatten

  let to_js_array scopes =
    Util.list_to_js_array (fun x -> x |> to_string |> Js.string) scopes
end

module AppMetadata = struct
  type t = { icon : string option; name : string; sender_id : string }

  let from_js obj_a =
    let icon = obj_a##.icon |> Js.Optdef.to_option |> Option.map Js.to_string
    and name = Js.to_string obj_a##.name
    and sender_id = Js.to_string obj_a##.senderId in
    { icon; name; sender_id }
end

module Network = struct
  type t = {
      name : string option
    ; rpc_url : string option
    ; type_ : NetworkType.t
  }

  let from_js obj_b =
    let name = obj_b##.name |> Js.Optdef.to_option |> Option.map Js.to_string
    and rpc_url =
      obj_b##.rpcUrl |> Js.Optdef.to_option |> Option.map Js.to_string
    and type_ = obj_b##._type |> Js.to_string |> NetworkType.from_string in
    { name; rpc_url; type_ }

  let to_js { name; rpc_url; type_ } : Bindings.Beacon.network Js.t =
    object%js
      val name = name |> Option.map Js.string |> Js.Optdef.option
      val rpcUrl = rpc_url |> Option.map Js.string |> Js.Optdef.option
      val _type = type_ |> NetworkType.to_string |> Js.string
    end
end

module Threshold = struct
  type t = { amount : string; timeframe : string }

  let from_js obj_c =
    let amount = Js.to_string obj_c##.amount
    and timeframe = Js.to_string obj_c##.timeframe in
    { amount; timeframe }
end

module AccountInfo = struct
  type t = {
      identifier : string
    ; address : string
    ; public_key : string
    ; scopes : PermissionScope.t list
    ; connected_at : int
    ; network : Network.t
    ; sender_id : string
    ; threshold : Threshold.t option
  }

  let from_js obj_d =
    let identifier = Js.to_string obj_d##.accountIdentifier
    and address = Js.to_string obj_d##.address
    and public_key = Js.to_string obj_d##.publicKey
    and scopes = PermissionScope.from_js_array obj_d##.scopes
    and connected_at = obj_d##.connectedAt
    and network = Network.from_js obj_d##.network
    and sender_id = Js.to_string obj_d##.senderId
    and threshold =
      obj_d##.threshold |> Js.Optdef.to_option |> Option.map Threshold.from_js
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
end

module PermissionResponse = struct
  type t = {
      id : string
    ; sender_id : string
    ; version : string
    ; app_metadata : AppMetadata.t option
    ; network : Network.t
    ; public_key : string
    ; scopes : PermissionScope.t list
  }

  let from_js obj_e =
    let id = Js.to_string obj_e##.id
    and sender_id = Js.to_string obj_e##.senderId
    and version = Js.to_string obj_e##.version
    and app_metadata =
      obj_e##.appMetadata
      |> Js.Optdef.to_option
      |> Option.map AppMetadata.from_js
    and network = Network.from_js obj_e##.network
    and public_key = Js.to_string obj_e##.publicKey
    and scopes = PermissionScope.from_js_array obj_e##.scopes in

    { id; sender_id; version; app_metadata; network; public_key; scopes }
end

module PermissionResponseOutput = struct
  type t = {
      response : PermissionResponse.t
    ; account_info : AccountInfo.t
    ; address : string
  }

  let from_js obj_f =
    let response = PermissionResponse.from_js obj_f
    and account_info = AccountInfo.from_js obj_f##.accountInfo
    and address = Js.to_string obj_f##.address in
    { response; account_info; address }
end

module BlockExplorer = struct
  type t = Bindings.Beacon.blockExplorer Js.t

  let get_address_link explorer address network =
    let address_js = Js.string address and network_js = Network.to_js network in
    explorer##getAddressLink address_js network_js
    |> Util.promise_to_lwt
    |> Lwt.map Js.to_string

  let get_transaction_link explorer transaction_id network =
    let transaction_js = Js.string transaction_id
    and network_js = Network.to_js network in
    explorer##getTransactionLink transaction_js network_js
    |> Util.promise_to_lwt
    |> Lwt.map Js.to_string
end

module DAppClient = struct
  type t = Bindings.Beacon.dAppClient Js.t
  type constr = (Bindings.Beacon.dAppClientOptions Js.t -> t) Js.constr

  let make ?icon_url ?app_url ?matrix_nodes ?preferred_network ~name () =
    let options =
      object%js
        val name = Js.string name
        val iconUrl = icon_url |> Option.map Js.string |> Js.Optdef.option
        val appUrl = app_url |> Option.map Js.string |> Js.Optdef.option

        val preferredNetwork =
          let network =
            let open Preface.Option.Monad in
            let+ network = preferred_network in
            network |> NetworkType.to_string |> Js.string
          in
          Js.Optdef.option network

        val matrixNodes =
          let nodes =
            let open Preface.Option.Monad in
            let+ list = matrix_nodes in
            list |> Util.list_to_js_array Js.string
          in
          Js.Optdef.option nodes
      end
    in
    let constr : constr = Js.Unsafe.global##._DAppClient in
    new%js constr options

  let request_permissions ?network ?scopes client =
    let options =
      object%js
        val network = network |> Option.map Network.to_js |> Js.Optdef.option

        val scopes =
          scopes |> Option.map PermissionScope.to_js_array |> Js.Optdef.option
      end
    in
    let open Lwt.Syntax in
    let+ output = client##requestPermissions options |> Util.promise_to_lwt in
    output |> PermissionResponseOutput.from_js

  let get_active_account client =
    let open Lwt.Syntax in
    let+ active_account = client##getActiveAccount |> Util.promise_to_lwt in
    active_account |> Js.Optdef.to_option |> Option.map AccountInfo.from_js

  let clear_active_account client =
    let open Lwt.Syntax in
    let+ () = client##clearActiveAccount |> Util.promise_to_lwt in
    ()

  let disconnect_wallet client = clear_active_account client
  let get_block_explorer client = client##.blockExplorer
end
