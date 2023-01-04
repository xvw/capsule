open Core_js

type 'message Vdom.Cmd.t +=
  | Beacon_sync of {
        on_success :
             cost_per_byte:Tezos_js.Tez.t
          -> Beacon_js.Account_info.t
          -> Tezos_js.Tez.t
          -> 'message
      ; on_failure : Tezos_js.RPC.error -> 'message
    }
  | Beacon_unsync of { on_success : unit -> 'message }
  | Stream_head of {
        address : string
      ; on_success : Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> 'message
    }

let beacon_sync on_success on_failure = Beacon_sync { on_success; on_failure }
let beacon_unsync on_success = Beacon_unsync { on_success }
let stream_head address on_success = Stream_head { address; on_success }

let get_balance client address =
  let open Tezos_js in
  Beacon_js.Client.rpc_call_head ~client ~entrypoint:RPC.get_balance
    (Contract_id.from_string address)

let get_parametric_constants client =
  let open Tezos_js in
  Beacon_js.Client.rpc_call_head ~client
    ~entrypoint:RPC.get_parametric_constants

let perform_beacon_sync client ctx on_success on_failure () =
  let open Lwt_util in
  let* potential_active_account = Beacon_js.Client.get_active_account client in
  let* active_info =
    match potential_active_account with
    | Some active_info -> return active_info
    | None ->
        let open Beacon_js.Permission_response_output in
        let+ { account_info; _ } =
          Beacon_js.Client.request_permissions client
        in
        account_info
  in
  let+ result =
    let*? consts = get_parametric_constants client in
    let+? potential_balance = get_balance client active_info.address in
    (potential_balance, Tezos_js.Constants.cost_per_byte consts)
  in
  match result with
  | Ok (balance, cost_per_byte) ->
      Vdom_blit.Cmd.send_msg ctx (on_success ~cost_per_byte active_info balance)
  | Error err -> Vdom_blit.Cmd.send_msg ctx (on_failure err)

let perform_beacon_unsync client ctx on_success () =
  let open Lwt_util in
  let+ () = Beacon_js.Client.disconnect_client client in
  Vdom_blit.Cmd.send_msg ctx (on_success ())

let perform_stream_head client ctx address on_success () =
  let open Lwt_util in
  let* _ =
    Beacon_js.Client.rpc_stream ?retention_policy:None ~client
      ~entrypoint:Tezos_js.RPC.monitor_heads ~on_chunk:(fun head ->
        let open Lwt_util in
        let+? balance = get_balance client address in
        Vdom_blit.Cmd.send_msg ctx (on_success balance head))
  in
  return ()

let register client =
  let open Vdom_blit in
  let handler =
    {
      Cmd.f =
        (* FIXME: Unse a proper error handler for exception*)
        (fun ctx -> function
          | Beacon_sync { on_success; on_failure } ->
              let () =
                Lwt.dont_wait
                  (perform_beacon_sync client ctx on_success on_failure)
                  Console.error
              in
              true
          | Beacon_unsync { on_success } ->
              let () =
                Lwt.dont_wait
                  (perform_beacon_unsync client ctx on_success)
                  Console.error
              in
              true
          | Stream_head { address; on_success } ->
              let () =
                Lwt.dont_wait
                  (perform_stream_head client ctx address on_success)
                  Console.error
              in
              true
          | _ -> false)
    }
  in
  register @@ cmd handler
