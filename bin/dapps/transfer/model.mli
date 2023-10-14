type trace = Pending of string | Error of string | Done of string

type sync_state = {
    account : Beacon.Account_info.t
  ; balance : Yourbones.tez
  ; head : Yourbones.Block_header.t option
  ; benefactor_address :
      (Yourbones.Address.t, Yourbones.Address.error) Dapps.Inputable.t
}

type state = Not_synced | Synced of sync_state | Loading
type t = { state : state; trace : trace list }

val init : (t * Message.t Vdom.Cmd.t) Lwt.t
val update : t -> Message.t -> t * Message.t Vdom.Cmd.t
