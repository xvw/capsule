(** JavaScript bindings and libraries exported by {i hell.js} *)

open Js_of_ocaml
open Util
open Js

(** {1 HighlightJS} *)

module Hljs : sig
  class type hljs =
    object
      method highlightAll : unit meth
    end
end

(** {1 BeaconWallet} *)

module Beacon : sig
  class type baseMessage =
    object
      method id : js_string t readonly_prop
      method senderId : js_string t readonly_prop
      method _type : js_string t readonly_prop
      method version : js_string t readonly_prop
    end

  class type appMetadata =
    object
      method icon : js_string t Optdef.t readonly_prop
      method name : js_string t readonly_prop
      method senderId : js_string t readonly_prop
    end

  class type network =
    object
      method name : js_string t Optdef.t readonly_prop
      method rpcUrl : js_string t Optdef.t readonly_prop
      method _type : js_string t readonly_prop
    end

  class type threshold =
    object
      method amount : js_string t readonly_prop
      method timeframe : js_string t readonly_prop
    end

  class type permissionResponse =
    object
      inherit baseMessage
      method appMetadata : appMetadata t Optdef.t readonly_prop
      method network : network t readonly_prop
      method publicKey : js_string t readonly_prop
      method scopes : js_string t js_array t readonly_prop
    end

  class type accountInfo =
    object
      method accountIdentifier : js_string t readonly_prop
      method address : js_string t readonly_prop
      method publicKey : js_string t readonly_prop
    end

  class type requestPermissionInput =
    object
      method network : network t Optdef.t readonly_prop
      method scopes : js_string t js_array t Optdef.t readonly_prop
    end

  class type permissionResponseOutput =
    object
      inherit permissionResponse
      method accountInfo : accountInfo t readonly_prop
      method address : js_string t readonly_prop
    end

  class type dAppClientOptions =
    object
      method name : js_string t readonly_prop
      method iconUrl : js_string t Optdef.t readonly_prop
      method appUrl : js_string t Optdef.t readonly_prop
      method matrixNodes : js_string t js_array t Optdef.t readonly_prop
      method preferredNetwork : js_string t Optdef.t readonly_prop
    end

  class type dAppClient =
    object
      inherit dAppClientOptions

      method requestPermissions :
        requestPermissionInput t -> permissionResponseOutput t promise meth

      method getActiveAccount : accountInfo t Optdef.t promise meth
    end
end
