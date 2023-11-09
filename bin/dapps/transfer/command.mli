val register : Beacon.Dapp_client.t -> unit

val synchronize_wallet :
     on_success:
       (account:Beacon.Account_info.t -> balance:Yourbones.Tez.t -> 'msg)
  -> on_failure:(error:string -> 'msg)
  -> 'msg Vdom.Cmd.t

val desynchronize_wallet : on_success:(unit -> 'msg) -> 'msg Vdom.Cmd.t

val stream_head :
     account:Beacon.Account_info.t
  -> on_success:
       (   new_balance:Yourbones.Tez.t
        -> new_head:Yourbones.Block_header.t
        -> 'msg)
  -> 'msg Vdom.Cmd.t

val perform_transfer :
     target:Yourbones.Address.t
  -> amount:Yourbones.tez
  -> on_success:
       (   target:Yourbones.Address.t
        -> amount:Yourbones.tez
        -> ( Beacon.Transaction_hash_response_output.t
           , [ `Request_operation_rejection of exn ] )
           result
        -> 'msg)
  -> 'msg Vdom.Cmd.t
