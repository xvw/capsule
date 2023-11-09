type trace = Pending of string | Error of string | Done of string

type sync_state = {
    account : Beacon.Account_info.t
  ; balance : Yourbones.tez
  ; head : Yourbones.Block_header.t option
  ; benefactor_address :
      ( Yourbones.Address.t
      , [ Yourbones.Address.error | `Same_address ] )
      Dapps.Inputable.t
  ; amount :
      ( Yourbones.Tez.t
      , [ Yourbones.Tez.error | `Invalid_amount ] )
      Dapps.Inputable.t
}

type state =
  | Not_synced
  | Synced of sync_state
  | Await_inclusion of (sync_state * int)
  | Loading

type t = { state : state; trace : trace list }

val init : (t * Message.t Vdom.Cmd.t) Lwt.t
val update : t -> Message.t -> t * Message.t Vdom.Cmd.t
