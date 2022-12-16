(** A Partial binding of {{:https://docs.walletbeacon.io/} Beacon Wallet}. *)

open Js_of_ocaml

module MessageType : sig
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

  val to_string : t -> string
  val from_string : string -> t
end

module NetworkType : sig
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

  val to_string : t -> string
  val from_string : string -> t
end

module PermissionScope : sig
  type t = ENCRYPT | OPERATION_REQUEST | SIGN | THRESHOLD

  val to_string : t -> string
  val from_string : string -> t option
end

module AppMetadata : sig
  type t = { icon : string option; name : string; sender_id : string }

  val from_js : Bindings.Beacon.appMetadata Js.t -> t
end

module Threshold : sig
  type t = { amount : string; timeframe : string }

  val from_js : Bindings.Beacon.threshold Js.t -> t
end

module AccountInfo : sig
  type t = { identifier : string; address : string; public_key : string }

  val from_js : Bindings.Beacon.accountInfo Js.t -> t
end

module Network : sig
  type t = {
      name : string option
    ; rpc_url : string option
    ; type_ : NetworkType.t
  }

  val from_js : Bindings.Beacon.network Js.t -> t
  val to_js : t -> Bindings.Beacon.network Js.t
end

module PermissionResponse : sig
  type t = {
      id : string
    ; sender_id : string
    ; version : string
    ; app_metadata : AppMetadata.t option
    ; network : Network.t
    ; public_key : string
    ; scopes : PermissionScope.t list
  }

  val from_js : Bindings.Beacon.permissionResponse Js.t -> t
end

module PermissionResponseOutput : sig
  type t = {
      response : PermissionResponse.t
    ; account_info : AccountInfo.t
    ; address : string
  }

  val from_js : Bindings.Beacon.permissionResponseOutput Js.t -> t
end

module DAppClient : sig
  type t

  val make :
       ?icon_url:string
    -> ?app_url:string
    -> ?matrix_nodes:string list
    -> ?preferred_network:NetworkType.t
    -> name:string
    -> unit
    -> t

  val request_permissions :
       ?network:Network.t
    -> ?scopes:PermissionScope.t list
    -> t
    -> PermissionResponseOutput.t Lwt.t

  val get_active_account : t -> AccountInfo.t option Lwt.t
end
