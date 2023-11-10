type 'msg Vdom.Cmd.t +=
  | Synchronize_wallet of {
        on_success :
          account:Beacon.Account_info.t -> balance:Yourbones.Tez.t -> 'msg
      ; on_failure : error:string -> 'msg
    }
  | Streaming_head of {
        account : Beacon.Account_info.t
      ; on_success :
             new_balance:Yourbones.Tez.t
          -> new_head:Yourbones.Block_header.t
          -> 'msg
    }
  | Desynchronize_wallet of (unit -> 'msg)
  | Perform_transfer of {
        target : Yourbones.Address.t
      ; amount : Yourbones.Tez.t
      ; on_success :
             target:Yourbones.Address.t
          -> amount:Yourbones.Tez.t
          -> ( Beacon.Transaction_hash_response_output.t
             , [ `Request_operation_rejection of exn ] )
             result
          -> 'msg
    }

let get_balance address =
  Yourbones_js.RPC.call ~node_address:Network.node_address
    Yourbones.RPC.Directory.get_balance Yourbones.Chain_id.main
    Yourbones.Block_id.head address

let dump_error err =
  let label, str =
    match err with
    | `Http_error code -> ("http-error", string_of_int code)
    | `Json_error s -> ("json-error", s)
    | `Json_exn e -> ("json-exn", Printexc.to_string e)
    | `Request_permissions_rejection e ->
        ("request-permissions-rejection", Printexc.to_string e)
  in

  Nightmare_js.Console.(string error) @@ label ^ ", " ^ str

let perform_wallet_synchronization dapp_client ctx on_success on_failure () =
  let open Dapps.Lwt_util in
  let* account = Beacon.Dapp_client.get_active_account dapp_client in
  let+ account_with_balance =
    let*? account =
      match account with
      | Some active_account -> Lwt.return_ok active_account
      | None ->
          let+? account =
            Beacon.Dapp_client.request_permissions ~network:Network.network
              dapp_client
          in
          account.account_info
    in
    let+? balance = get_balance account.address in
    (account, balance)
  in
  let message =
    match account_with_balance with
    | Ok (account, balance) -> on_success ~account ~balance
    | Error err ->
        let error = "Impossible de connecter le wallet" in
        let () = dump_error err in
        let () = Nightmare_js.Console.(string error) error in
        on_failure ~error
  in
  Vdom_blit.Cmd.send_msg ctx message

let perform_wallet_desynchronization dapp_client ctx on_success () =
  let open Dapps.Lwt_util in
  let+ () = Beacon.Dapp_client.clear_active_account dapp_client in
  let message = on_success () in
  Vdom_blit.Cmd.send_msg ctx message

let perform_streaming_head ctx account on_success () =
  let open Dapps.Lwt_util in
  let* _ =
    Yourbones_js.RPC.stream
      ~on_chunk:(fun new_head ->
        let () = Nightmare_js.Console.(string log) "New block" in
        let+? new_balance = get_balance account.Beacon.Account_info.address in
        let message = on_success ~new_balance ~new_head in
        Vdom_blit.Cmd.send_msg ctx message)
      ~node_address:Network.node_address Yourbones.RPC.Directory.monitor_heads
      Yourbones.Chain_id.main
  in
  return ()

let perform_performing_transfer dapp_client ctx target amount on_success () =
  let open Dapps.Lwt_util in
  let+ output =
    Beacon.Dapp_client.request_simple_transaction ~destination:target
      dapp_client amount
  in
  Vdom_blit.Cmd.send_msg ctx (on_success ~target ~amount output)

let register dapp_client =
  let open Vdom_blit in
  let handler ctx = function
    | Synchronize_wallet { on_success; on_failure } ->
        let () =
          Lwt.dont_wait
            (perform_wallet_synchronization dapp_client ctx on_success
               on_failure)
            Nightmare_js.Console.error
        in
        true
    | Desynchronize_wallet on_success ->
        let () =
          Lwt.dont_wait
            (perform_wallet_desynchronization dapp_client ctx on_success)
            Nightmare_js.Console.error
        in
        true
    | Streaming_head { account; on_success } ->
        let () =
          Lwt.dont_wait
            (perform_streaming_head ctx account on_success)
            Nightmare_js.Console.error
        in
        true
    | Perform_transfer { target; amount; on_success } ->
        let () =
          Lwt.dont_wait
            (perform_performing_transfer dapp_client ctx target amount
               on_success)
            Nightmare_js.Console.error
        in
        true
    | _ -> false
  in

  register @@ cmd Cmd.{ f = handler }

let synchronize_wallet ~on_success ~on_failure =
  Synchronize_wallet { on_success; on_failure }

let desynchronize_wallet ~on_success = Desynchronize_wallet on_success
let stream_head ~account ~on_success = Streaming_head { account; on_success }

let perform_transfer ~target ~amount ~on_success =
  Perform_transfer { target; amount; on_success }
