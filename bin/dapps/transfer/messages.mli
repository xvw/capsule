type t =
  | Beacon_sync
  | Beacon_unsync
  | Beacon_synced of {
        account_info : Beacon_js.Account_info.t
      ; balance : Tezos_js.Tez.t
      ; cost_per_byte : Tezos_js.Tez.t
    }
  | Beacon_unsynced
  | Input_address_form of string
  | Validated_address of {
        address : string
      ; is_valid : bool
      ; is_revealed : bool
    }
  | New_head of { balance : Tezos_js.Tez.t; head : Tezos_js.Monitored_head.t }
  | Save_error of string

val beacon_sync : _ -> t

val beacon_synced :
     cost_per_byte:Tezos_js.Tez.t
  -> Beacon_js.Account_info.t
  -> Tezos_js.Tez.t
  -> t

val validated_address : string -> (bool, 'a) result -> t
val beacon_unsync : _ -> t
val beacon_unsynced : unit -> t
val input_address_form : string -> t
val new_head : Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> t
val save_error : string -> t
