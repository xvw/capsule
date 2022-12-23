open Js_of_ocaml
open Core_js

type 'message Vdom.Cmd.t +=
  | Sync_wallet_cmd of {
        callback :
             Beacon_js.Account_info.t
          -> (Tezos_js.Tez.t, Tezos_js.RPC.error) result
          -> 'message
    }
  | Unsync_wallet_cmd of { callback : unit -> 'message }
  | Check_address_cmd of {
        address : string
      ; callback : string -> bool -> 'message
    }
  | Stream_head_cmd of {
        address : string
      ; callback : Tezos_js.Tez.t -> Tezos_js.Monitored_head.t -> 'message
    }

type message =
  | Connect_wallet
  | Disconnect_wallet
  | Wallet_connected of {
        account_info : Beacon_js.Account_info.t
      ; balance : Tezos_js.Tez.t
    }
  | Wallet_disconnected
  | Input_address_form of string
  | Address_checked of string * bool
  | New_head of { balance : Tezos_js.Tez.t; head : Tezos_js.Monitored_head.t }

type synced_state = {
    account_info : Beacon_js.Account_info.t
  ; balance : Tezos_js.Tez.t
  ; form_address_state : string * bool
  ; head : Tezos_js.Monitored_head.t option
}

type model = Not_synced | Synced of synced_state

let get_balance client address =
  let open Tezos_js in
  (Beacon_js.Client.rpc_call_head ~client ~entrypoint:RPC.get_balance)
    (Contract_id.from_string address)

let reach_contract client address =
  let open Tezos_js in
  Beacon_js.Client.rpc_reachable_call_head ~client ~entrypoint:RPC.get_balance
    (Contract_id.from_string address)

let relaxed_get_balance client address =
  let open Lwt.Syntax in
  let+ x = get_balance client address in
  Result.fold ~ok:(fun x -> x) ~error:(fun _ -> Tezos_js.Tez.zero) x

let sync_wallet ~callback = Sync_wallet_cmd { callback }
let unsync_wallet ~callback = Unsync_wallet_cmd { callback }

let watch_head ~callback ~account () =
  Stream_head_cmd { callback; address = account.Beacon_js.Account_info.address }

let check_input_address ~callback ~address =
  Check_address_cmd { address; callback }

let retrieve_or_connect client ctx callback () =
  let open Lwt.Syntax in
  let* potential_active_account = Beacon_js.Client.get_active_account client in
  let* active_info =
    match potential_active_account with
    | Some active_info -> Lwt.return active_info
    | None ->
        let+ Beacon_js.Permission_response_output.{ account_info; _ } =
          Beacon_js.Client.request_permissions client
        in

        account_info
  in

  let+ potential_balance = get_balance client active_info.address in
  Vdom_blit.Cmd.send_msg ctx (callback active_info potential_balance)

let disconnect_wallet client ctx callback () =
  let open Lwt.Syntax in
  let+ () = Beacon_js.Client.disconnect_client client in
  Vdom_blit.Cmd.send_msg ctx (callback ())

let check_address client ctx address callback () =
  let len = String.length address in
  let open Lwt.Syntax in
  let+ is_reachable =
    if len = 36 then
      match String.sub address 0 3 with
      | "tz1" | "KT1" -> reach_contract client address
      | _ -> Lwt.return_false
    else Lwt.return_false
  in
  Vdom_blit.Cmd.send_msg ctx (callback address is_reachable)

let stream_head client ctx address callback () =
  Beacon_js.Client.rpc_stream ~client ~entrypoint:Tezos_js.RPC.monitor_heads
    ~on_chunk:(fun head ->
      let open Lwt_util in
      let+? balance = get_balance client address in
      Vdom_blit.Cmd.send_msg ctx (callback balance head))

let register client =
  let open Vdom_blit in
  let handler =
    {
      Cmd.f =
        (fun ctx -> function
          | Sync_wallet_cmd { callback } ->
              let () = Lwt.async (retrieve_or_connect client ctx callback) in
              true
          | Unsync_wallet_cmd { callback } ->
              let () = Lwt.async (disconnect_wallet client ctx callback) in
              true
          | Check_address_cmd { address; callback } ->
              let () = Lwt.async (check_address client ctx address callback) in
              true
          | Stream_head_cmd { address; callback } ->
              let () =
                Lwt.async (fun () ->
                    let open Lwt_util in
                    let* _ = stream_head client ctx address callback () in
                    Lwt.return_unit)
              in
              true
          | _ -> false)
    }
  in
  register @@ cmd handler

let update_not_sync model = function
  | Connect_wallet ->
      Vdom.return model
        ~c:
          [
            sync_wallet ~callback:(fun account_info -> function
              | Error err ->
                  let () =
                    Console.(message error) (Tezos_js.Error.to_string err)
                  in
                  Disconnect_wallet
              | Ok balance -> Wallet_connected { account_info; balance })
          ]
  | Wallet_connected { account_info; balance } ->
      Vdom.return
      @@ Synced
           {
             account_info
           ; balance
           ; form_address_state = ("", false)
           ; head = None
           }
  | _ -> Vdom.return model

let update_sync model state = function
  | Disconnect_wallet ->
      Vdom.return model
        ~c:[ unsync_wallet ~callback:(fun () -> Wallet_disconnected) ]
  | Wallet_disconnected -> Vdom.return Not_synced
  | Input_address_form value ->
      Vdom.return
        (Synced { state with form_address_state = (value, false) })
        ~c:
          [
            check_input_address
              ~callback:(fun value is_valid ->
                Address_checked (value, is_valid))
              ~address:value
          ]
  | Address_checked (value, is_valid) ->
      Vdom.return (Synced { state with form_address_state = (value, is_valid) })
  | New_head { balance; head } ->
      Vdom.return (Synced { state with balance; head = Some head })
  | _ -> Vdom.return model

let update model message =
  match model with
  | Not_synced -> update_not_sync model message
  | Synced state -> update_sync model state message

let not_sync_view =
  let open Vdom in
  let open Vdom_ui in
  div
    ~a:[ class_ "not-connected" ]
    [
      button
        ~a:[ onclick (fun _ -> Connect_wallet); class_ "connection-button" ]
        [ text "connect wallet" ]
    ]

let transfer_input_section inputed_address is_valid_address =
  let open Vdom in
  let open Vdom_ui in
  div
    ~a:[ class_ "transfer-fill-address" ]
    [
      div
        ~a:[ class_ "transfer-input-address" ]
        [
          input
            ~a:
              [
                type_ "text"
              ; placeholder "addresse du bénéficiaire"
              ; value inputed_address
              ; oninput (fun input_value -> Input_address_form input_value)
              ]
            []
        ]
    ; div [ text (if is_valid_address then "✔" else "✖") ]
    ]

let bottom_section account_info head =
  let open Vdom in
  let open Vdom_ui in
  let open Beacon_js.Account_info in
  div
    ~a:[ class_ "bottom" ]
    [
      div
        ~a:[ class_ "network" ]
        [ text (Tezos_js.Network.to_string account_info.network.type_) ]
    ; div
        ~a:[ class_ "tezos-head" ]
        [
          text
            (Option.fold
               (fun () -> "loading")
               (fun x ->
                 Tezos_js.Address.to_short_string x.Tezos_js.Monitored_head.hash)
               head)
        ]
    ]

let sync_view account_info balance head (inputed_address, is_valid_address) =
  let open Vdom_ui in
  div
    [
      connected_badge
        (fun _ -> Disconnect_wallet)
        account_info.Beacon_js.Account_info.address balance
    ; transfer_input_section inputed_address is_valid_address
    ; bottom_section account_info head
    ]

let view = function
  | Not_synced -> not_sync_view
  | Synced { account_info; balance; form_address_state; head } ->
      sync_view account_info balance head form_address_state

let mount container_id =
  match Js_browser.(Document.(get_element_by_id document container_id)) with
  | None ->
      let () = Console.(message error "Unable to find root node") in
      Lwt.return_unit
  | Some root ->
      let open Lwt.Syntax in
      let client =
        Beacon_js.Client.make ~network:Tezos_js.Network.Nodes.Ghostnet.ecadlabs
          ~name:"transfer" ()
      in
      let* init =
        let* account = Beacon_js.Client.get_active_account client in
        Option.fold
          (fun () -> Lwt.return @@ Vdom.return Not_synced)
          (fun account_info ->
            let+ balance =
              relaxed_get_balance client
                account_info.Beacon_js.Account_info.address
            in
            Vdom.return
              ~c:
                [
                  watch_head ~account:account_info
                    ~callback:(fun balance head -> New_head { balance; head })
                    ()
                ]
            @@ Synced
                 {
                   account_info
                 ; balance
                 ; form_address_state = ("", false)
                 ; head = None
                 })
          account
      in

      let app = Vdom.app ~init ~view ~update () in
      let () = register client in
      let () = Js_browser.Element.remove_all_children root in
      let () =
        Vdom_blit.run app
        |> Vdom_blit.dom
        |> Js_browser.Element.append_child root
      in
      Lwt.return_unit

class type input =
  object
    method containerId : Js.js_string Js.t Js.readonly_prop
  end

let entrypoint =
  object%js
    method mount input =
      let container_id = Js.to_string input##.containerId in
      mount container_id
  end
