val beacon_sync :
     (   cost_per_byte:Tezos_js.Tez.t
      -> Beacon_js.Account_info.t
      -> Tezos_js.Tez.t
      -> 'message)
  -> (Tezos_js.RPC.error -> 'message)
  -> 'message Vdom.Cmd.t

val beacon_unsync : (unit -> 'message) -> 'message Vdom.Cmd.t

val validated_address :
     string
  -> ((bool, Tezos_js.Address.error) result -> 'message)
  -> 'message Vdom.Cmd.t

val stream_head :
     Tezos_js.Address.t
  -> (Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> 'message)
  -> 'message Vdom.Cmd.t

val get_balance :
     Beacon_js.Client.t
  -> Tezos_js.Address.t
  -> (Tezos_js.Tez.t, Tezos_js.RPC.error) result Lwt.t

val get_parametric_constants :
  Beacon_js.Client.t -> (Tezos_js.Constants.t, Tezos_js.RPC.error) result Lwt.t

val register : Beacon_js.Client.t -> unit
