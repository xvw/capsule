type base_fee = First | Second | Third

type t =
  | Beacon_sync
  | Beacon_unsync
  | Beacon_synced of {
        account_info : Beacon_js.Account_info.t
      ; balance : Tezos_js.Tez.t
      ; constants : Tezos_js.Constants.t
    }
  | Beacon_unsynced
  | Change_base_fee of base_fee
  | Input_address_form of string
  | Input_amount_form of string
  | Validated_address of {
        address : string
      ; is_valid : bool
      ; is_revealed : bool
    }
  | New_head of { balance : Tezos_js.Tez.t; head : Tezos_js.Monitored_head.t }
  | Transfer of { destination : Tezos_js.Address.t; amount : Tezos_js.Tez.t }
  | Fill_address
  | Await_transfer
  | Save_error of string

val beacon_sync : _ -> t

val beacon_synced :
     constants:Tezos_js.Constants.t
  -> Beacon_js.Account_info.t
  -> Tezos_js.Tez.t
  -> t

val validated_address : string -> (bool, 'a) result -> t
val beacon_unsync : _ -> t
val beacon_unsynced : unit -> t
val input_address_form : string -> t
val input_amount_form : string -> t
val new_head : Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> t
val save_error : string -> t
val change_base_fee : base_fee -> t
val transfer : Tezos_js.Address.t -> Tezos_js.Tez.t -> t
