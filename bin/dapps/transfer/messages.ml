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

let beacon_sync _ = Beacon_sync
let beacon_unsync _ = Beacon_unsync
let beacon_synced account_info balance = Beacon_synced { account_info; balance }
let beacon_unsynced () = Beacon_unsynced
let input_address_form input_value = Input_address_form input_value
let save_error error = Save_error error
