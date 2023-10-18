(** A Work-in-progress binding of
    {{:https://docs.walletbeacon.io/} Beacon Wallet}. *)

open Js_of_ocaml
open Js
open Core_js

type permission_scopes = js_string t js_array t

class type baseMessage = object
  method id : js_string t readonly_prop
  method senderId : js_string t readonly_prop
  method _type : js_string t readonly_prop
  method version : js_string t readonly_prop
end

class type network = object
  method name : js_string t or_undefined readonly_prop
  method rpcUrl : js_string t or_undefined readonly_prop
  method _type : js_string t readonly_prop
end

class type threshold = object
  method amount : js_string t readonly_prop
  method timeframe : js_string t readonly_prop
end

class type permissionResponse = object
  inherit baseMessage
  method network : network t readonly_prop
  method publicKey : js_string t readonly_prop
  method scopes : permission_scopes readonly_prop
end

class type accountInfo = object
  method accountIdentifier : js_string t readonly_prop
  method address : js_string t readonly_prop
  method publicKey : js_string t readonly_prop
  method scopes : permission_scopes readonly_prop
  method connectedAt : int readonly_prop
  method network : network t readonly_prop
  method senderId : js_string t readonly_prop
  method threshold : threshold t or_undefined readonly_prop
end

class type requestPermissionInput = object
  method network : network t or_undefined readonly_prop
  method scopes : permission_scopes or_undefined readonly_prop
end

class type permissionResponseOutput = object
  inherit permissionResponse
  method accountInfo : accountInfo t readonly_prop
  method address : js_string t readonly_prop
end

class type blockExplorer = object
  method getAddressLink : js_string t -> network t -> js_string t promise meth

  method getTransactionLink :
    js_string t -> network t -> js_string t promise meth
end

class type partialOperation = object
  method kind : js_string t readonly_prop
  method destination : js_string t readonly_prop
  method amount : js_string t readonly_prop
end

class type requestOperationInput = object
  method operationDetails : partialOperation t js_array t readonly_prop
end

class type operationResponse = object
  inherit baseMessage
  method transactionHash : js_string t readonly_prop
end

class type dAppClientOptions = object
  method name : js_string t readonly_prop
  method iconUrl : js_string t or_undefined readonly_prop
  method appUrl : js_string t or_undefined readonly_prop
  method matrixNodes : js_string t js_array t or_undefined readonly_prop
  method preferredNetwork : js_string t or_undefined readonly_prop
end

class type dAppClient = object
  inherit dAppClientOptions
  method blockExplorer : blockExplorer t readonly_prop

  method requestPermissions :
    requestPermissionInput t -> permissionResponseOutput t promise meth

  method requestOperation :
    requestOperationInput t -> operationResponse t promise meth

  method getActiveAccount : accountInfo t or_undefined promise meth
  method clearActiveAccount : unit promise meth
end
