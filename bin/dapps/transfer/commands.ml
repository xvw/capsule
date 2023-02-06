open Core_js

type 'message Vdom.Cmd.t +=
  | Beacon_sync of {
        on_success :
             constants:Tezos_js.Constants.t
          -> Beacon_js.Account_info.t
          -> Tezos_js.Tez.t
          -> 'message
      ; on_failure : Tezos_js.RPC.error -> 'message
    }
  | Beacon_unsync of { on_success : unit -> 'message }
  | Validate_address of {
        address : string
      ; on_success : (bool, Tezos_js.Address.error) result -> 'message
    }
  | Stream_head of {
        address : string
      ; on_success : Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> 'message
    }
  | Perform_transfer of {
        destination : Tezos_js.Address.t
      ; amount : Tezos_js.Tez.t
      ; on_success : Tezos_js.Address.t -> Tezos_js.Tez.t -> 'message
    }

let beacon_sync on_success on_failure = Beacon_sync { on_success; on_failure }
let beacon_unsync on_success = Beacon_unsync { on_success }
let stream_head address on_success = Stream_head { address; on_success }

let perform_transfer destination amount on_success =
  Perform_transfer { destination; amount; on_success }

let validated_address address on_success =
  Validate_address { address; on_success }

let get_balance client address =
  let open Tezos_js in
  Beacon_js.Client.rpc_call_head ~client ~entrypoint:RPC.get_balance
    (Contract_id.from_string address)

let get_parametric_constants client =
  let open Tezos_js in
  Beacon_js.Client.rpc_call_head ~client
    ~entrypoint:RPC.get_parametric_constants

let is_a_revealed_address client address =
  let open Tezos_js in
  let open Lwt_util in
  let+ result =
    Beacon_js.Client.rpc_call_head ~client ~entrypoint:RPC.get_manager_key
      (Contract_id.from_string address)
  in
  match result with Ok (Some _) -> true | _ -> false

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
    (potential_balance, consts)
  in
  match result with
  | Ok (balance, constants) ->
      Vdom_blit.Cmd.send_msg ctx (on_success ~constants active_info balance)
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

let perform_address_reveal client ctx address on_success () =
  let open Lwt_util in
  let address = Tezos_js.Address.validate address in
  let+ result =
    Core_js.Result.fold
      ~ok:(fun address ->
        let* x = is_a_revealed_address client address in
        return_ok x)
      ~error:return_error address
  in
  Vdom_blit.Cmd.send_msg ctx (on_success result)

let perform_perform_transfer client ctx destination amount on_success () =
  let open Lwt_util in
  let+ () = Beacon_js.Client.request_transfer ~destination ~amount client in
  Vdom_blit.Cmd.send_msg ctx (on_success destination amount)

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
          | Validate_address { address; on_success } ->
              let () =
                Lwt.dont_wait
                  (perform_address_reveal client ctx address on_success)
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
          | Perform_transfer { destination; amount; on_success } ->
              let () =
                Lwt.dont_wait
                  (perform_perform_transfer client ctx destination amount
                     on_success)
                  Console.error
              in
              true
          | _ -> false)
    }
  in
  register @@ cmd handler
