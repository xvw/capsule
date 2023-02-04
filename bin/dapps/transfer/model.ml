open Core_js

type address_form =
  | Invalid of string
  | Unknown of Tezos_js.Address.t
  | Revealed of Tezos_js.Address.t

type diagnosis =
  | Header_not_reacheable
  | Address_invalid
  | Same_origin_address
  | Invalid_amount
  | Too_high_amount

type synced_state = {
    account_info : Beacon_js.Account_info.t
  ; balance : Tezos_js.Tez.t
  ; address_form : address_form
  ; amount_form : string * Tezos_js.Tez.t option * bool
  ; base_fee : Messages.base_fee
  ; constants : Tezos_js.Constants.t
  ; head : Tezos_js.Monitored_head.t option
}

type state = Not_sync | Sync of synced_state
type t = { error : string option; state : state }

let fill_address_form address is_valid is_revealed =
  if not is_valid then Invalid address
  else if not is_revealed then Unknown address
  else Revealed address

let get_address { address_form; _ } =
  match address_form with
  | Invalid x -> (x, false)
  | Unknown x -> (x, true)
  | Revealed x -> (x, true)

let init_sync account_info balance constants =
  Sync
    {
      account_info
    ; balance
    ; address_form = Invalid ""
    ; amount_form = ("", None, false)
    ; base_fee = Messages.First
    ; head = None
    ; constants
    }

let transfer_diagnosis state =
  let head_reacheable =
    if Stdlib.Option.is_some state.head then [] else [ Header_not_reacheable ]
  and address_valid =
    match state.address_form with
    | Invalid _ -> [ Address_invalid ]
    | Unknown x | Revealed x ->
        if String.equal x state.account_info.address then
          [ Same_origin_address ]
        else []
  and amount_valid =
    match state.amount_form with
    | _, Some amount, _ ->
        Option.fold
          (fun () -> [ Too_high_amount ])
          (fun limit ->
            if Tezos_js.Tez.compare amount limit > 0 then [ Too_high_amount ]
            else [])
          Tezos_js.Tez.(state.balance - from_int64' 2L)
    | _ -> [ Invalid_amount ]
  in

  head_reacheable @ address_valid @ amount_valid

let can_perform_transfer state =
  match transfer_diagnosis state with [] -> true | _ -> false

let update_not_sync model = function
  | Messages.Beacon_sync ->
      Vdom.return model
        ~c:
          [
            Commands.beacon_sync Messages.beacon_synced
              (Messages.save_error % Tezos_js.Error.to_string)
          ]
  | Messages.Beacon_synced { account_info; balance; constants } ->
      let address = account_info.address in
      Vdom.return
        ~c:[ Commands.stream_head address Messages.new_head ]
        { model with state = init_sync account_info balance constants }
  | _ -> Vdom.return model

let update_sync model state = function
  | Messages.Beacon_unsync ->
      Vdom.return model ~c:[ Commands.beacon_unsync Messages.beacon_unsynced ]
  | Messages.Beacon_unsynced -> Vdom.return { model with state = Not_sync }
  | Messages.Input_address_form value ->
      Vdom.return
        { model with state = Sync { state with address_form = Invalid value } }
        ~c:
          [
            Commands.validated_address value (Messages.validated_address value)
          ]
  | Messages.Input_amount_form value ->
      let amount = Tezos_js.Tez.from_string value in
      let flag = match amount with None -> false | Some _ -> true in
      Vdom.return
        {
          model with
          state = Sync { state with amount_form = (value, amount, flag) }
        }
  | Messages.Validated_address result ->
      let address_form =
        fill_address_form result.address result.is_valid result.is_revealed
      in
      Vdom.return { model with state = Sync { state with address_form } }
  | Messages.New_head { balance; head } ->
      Vdom.return
        { model with state = Sync { state with balance; head = Some head } }
  | Messages.Change_base_fee value ->
      Vdom.return { model with state = Sync { state with base_fee = value } }
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

let relaxed_get_parametric_constants client =
  let open Lwt_util in
  let+ x = Commands.get_parametric_constants client in
  Result.fold ~ok:(fun x -> x) ~error:(fun _ -> Tezos_js.Constants.default) x

let init client =
  let open Lwt_util in
  let* account = Beacon_js.Client.get_active_account client in
  match account with
  | None -> return @@ Vdom.return { error = None; state = Not_sync }
  | Some account_info ->
      let address = account_info.address in
      let* constants = relaxed_get_parametric_constants client in
      let+ balance = relaxed_get_balance client address in
      Vdom.return
        ~c:[ Commands.stream_head address Messages.new_head ]
        { error = None; state = init_sync account_info balance constants }
