type t

val make :
     ?icon_url:string
  -> ?app_url:string
  -> network:Tezos_js.Network.t
  -> name:string
  -> unit
  -> t

val request_permissions :
  ?scopes:Permission_scope.t list -> t -> Permission_response_output.t Lwt.t

val get_active_account : t -> Account_info.t option Lwt.t
val clear_active_account : t -> unit Lwt.t
val disconnect_client : t -> unit Lwt.t
val get_block_explorer : t -> Block_explorer.t

val rpc_call :
     client:t
  -> entrypoint:
       (   unit
        -> ( 'meth
           , 'encoding
           , 'b
           , ('encoding, string) result Lwt.t )
           Tezos_js.Entrypoint.t)
  -> 'b

val rpc_call_head :
     client:t
  -> entrypoint:
       (   unit
        -> ( 'meth
           , 'encoding
           , Tezos_js.Chain_id.t -> Tezos_js.Block_id.t -> 'b
           , ('encoding, string) result Lwt.t )
           Tezos_js.Entrypoint.t)
  -> 'b
