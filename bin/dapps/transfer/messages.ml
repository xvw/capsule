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
  | Save_error of string

let beacon_sync _ = Beacon_sync
let beacon_unsync _ = Beacon_unsync

let beacon_synced ~constants account_info balance =
  Beacon_synced { account_info; balance; constants }

let validated_address address result =
  let is_valid, is_revealed =
    match result with Error _ -> (false, false) | Ok x -> (true, x)
  in
  Validated_address { address; is_valid; is_revealed }

let beacon_unsynced () = Beacon_unsynced
let input_address_form input_value = Input_address_form input_value
let input_amount_form input_value = Input_amount_form input_value
let new_head balance head = New_head { balance; head }
let save_error error = Save_error error
let change_base_fee value = Change_base_fee value
