type t =
  | With_error of string
  | Ask_for_sync
  | Ask_for_unsync
  | Synced_wallet of {
        account : Beacon.Account_info.t
      ; balance : Yourbones.tez
    }
  | Unsync_wallet
  | Unsynced_wallet
  | New_head of {
        new_balance : Yourbones.Tez.t
      ; new_head : Yourbones.Block_header.t
    }
  | Fill_benefactor_address of string
  | Fill_amount of string
  | Transfer
  | Synced_transfer

let ask_for_sync _ = Ask_for_sync
let ask_for_unsync _ = Ask_for_unsync
let synced_wallet ~account ~balance = Synced_wallet { account; balance }
let with_error ~error = With_error error
let unsynced_wallet () = Unsynced_wallet
let new_head ~new_balance ~new_head = New_head { new_balance; new_head }
let fill_benefactor_adress value = Fill_benefactor_address value
let fill_amount value = Fill_amount value

let perform_sync =
  Command.synchronize_wallet ~on_success:synced_wallet ~on_failure:with_error

let perform_unsync = Command.desynchronize_wallet ~on_success:unsynced_wallet
let stream_head account = Command.stream_head ~account ~on_success:new_head
let transfer _ = Transfer
