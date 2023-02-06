type address_form =
  | Invalid of string
  | Unknown of Tezos_js.Address.t
  | Revealed of Tezos_js.Address.t

type synced_state = {
    account_info : Beacon_js.Account_info.t
  ; balance : Tezos_js.Tez.t
  ; address_form : address_form
  ; amount_form : string * Tezos_js.Tez.t option * bool
  ; base_fee : Messages.base_fee
  ; constants : Tezos_js.Constants.t
  ; head : Tezos_js.Monitored_head.t option
}

type diagnosis =
  | Header_not_reacheable
  | Address_invalid
  | Same_origin_address
  | Invalid_amount
  | Too_high_amount

type state = Not_sync | Sync of synced_state | Await of synced_state
type t = { error : string option; state : state }

val get_address : synced_state -> string * bool
val update : t -> Messages.t -> t * Messages.t Vdom.Cmd.t
val init : Beacon_js.Client.t -> (t * Messages.t Vdom.Cmd.t) Lwt.t

val transfer_diagnosis :
  synced_state -> (Tezos_js.Address.t * Tezos_js.Tez.t, diagnosis list) result

val can_perform_transfer : synced_state -> bool
