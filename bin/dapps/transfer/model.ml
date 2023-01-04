open Core_js

type synced_state = {
    account_info : Beacon_js.Account_info.t
  ; balance : Tezos_js.Tez.t
  ; address_form : string * bool
  ; cost_per_byte : Tezos_js.Tez.t
  ; head : Tezos_js.Monitored_head.t option
}

type state = Not_sync | Sync of synced_state
type t = { error : string option; state : state }

let update_not_sync model = function
  | Messages.Beacon_sync ->
      Vdom.return model
        ~c:
          [
            Commands.beacon_sync Messages.beacon_synced
              (Messages.save_error % Tezos_js.Error.to_string)
          ]
  | Messages.Beacon_synced { account_info; balance; cost_per_byte } ->
      let address = account_info.address in
      Vdom.return
        ~c:[ Commands.stream_head address Messages.new_head ]
        {
          model with
          state =
            Sync
              {
                account_info
              ; balance
              ; address_form = ("", false)
              ; head = None
              ; cost_per_byte
              }
        }
  | _ -> Vdom.return model

let update_sync model state = function
  | Messages.Beacon_unsync ->
      Vdom.return model ~c:[ Commands.beacon_unsync Messages.beacon_unsynced ]
  | Messages.Beacon_unsynced -> Vdom.return { model with state = Not_sync }
  | Messages.Input_address_form value ->
      let address_form = (value, Tezos_js.Address.is_valid value) in
      Vdom.return { model with state = Sync { state with address_form } }
  | Messages.New_head { balance; head } ->
      Vdom.return
        { model with state = Sync { state with balance; head = Some head } }
  | _ -> Vdom.return model

let update model = function
  | Messages.Save_error error -> Vdom.return { model with error = Some error }
  | message -> (
      let model = { model with error = None } in
      match model.state with
      | Not_sync -> update_not_sync model message
      | Sync state -> update_sync model state message)

let relaxed_get_balance client address =
  let open Lwt_util in
  let+ x = Commands.get_balance client address in
  Result.fold ~ok:(fun x -> x) ~error:(fun _ -> Tezos_js.Tez.zero) x

let relaxed_get_cost_per_byte client =
  let open Lwt_util in
  let+ x = Commands.get_parametric_constants client in
  Result.fold
    ~ok:(fun x -> Tezos_js.Constants.cost_per_byte x)
    ~error:(fun _ -> Tezos_js.Tez.of_mutez @@ Z.of_int 250)
    x

let init client =
  let open Lwt_util in
  let* account = Beacon_js.Client.get_active_account client in
  match account with
  | None -> return @@ Vdom.return { error = None; state = Not_sync }
  | Some account_info ->
      let address = account_info.address in
      let* cost_per_byte = relaxed_get_cost_per_byte client in
      let+ balance = relaxed_get_balance client address in
      Vdom.return
        ~c:[ Commands.stream_head address Messages.new_head ]
        {
          error = None
        ; state =
            Sync
              {
                account_info
              ; balance
              ; address_form = ("", false)
              ; head = None
              ; cost_per_byte
              }
        }
