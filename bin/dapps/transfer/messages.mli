type t =
  | Beacon_sync
  | Beacon_unsync
  | Beacon_synced of {
        account_info : Beacon_js.Account_info.t
      ; balance : Tezos_js.Tez.t
    }
  | Beacon_unsynced
  | Input_address_form of string
  | Save_error of string

val beacon_sync : _ -> t
val beacon_synced : Beacon_js.Account_info.t -> Tezos_js.Tez.t -> t
val beacon_unsync : _ -> t
val beacon_unsynced : unit -> t
val input_address_form : string -> t
val save_error : string -> t
