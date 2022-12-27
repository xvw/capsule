val beacon_sync :
     (Beacon_js.Account_info.t -> Tezos_js.Tez.t -> 'message)
  -> (Tezos_js.RPC.error -> 'message)
  -> 'message Vdom.Cmd.t

val beacon_unsync : (unit -> 'message) -> 'message Vdom.Cmd.t

val get_balance :
     Beacon_js.Client.t
  -> Tezos_js.Address.t
  -> (Tezos_js.Tez.t, Tezos_js.RPC.error) result Lwt.t

val register : Beacon_js.Client.t -> unit
