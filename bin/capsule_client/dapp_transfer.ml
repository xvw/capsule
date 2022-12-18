open Js_of_ocaml

type 'message Vdom.Cmd.t +=
  | Sync_wallet_cmd of { callback : Beacon_js.Account_info.t -> 'message }
  | Unsync_wallet_cmd of { callback : unit -> 'message }

let sync_wallet ~callback = Sync_wallet_cmd { callback }
let unsync_wallet ~callback = Unsync_wallet_cmd { callback }

let retreive_or_connect client ctx callback () =
  let open Lwt.Syntax in
  let* potential_active_account =
    Beacon_js.DApp_client.get_active_account client
  in
  let+ active_info =
    match potential_active_account with
    | Some active_info -> Lwt.return active_info
    | None ->
        let+ Beacon_js.Permission_response_output.{ account_info; _ } =
          Beacon_js.DApp_client.request_permissions client
        in

        account_info
  in
  Vdom_blit.Cmd.send_msg ctx (callback active_info)

let disconnect_wallet client ctx callback () =
  let open Lwt.Syntax in
  let+ () = Beacon_js.DApp_client.disconnect_wallet client in
  Vdom_blit.Cmd.send_msg ctx (callback ())

let register client =
  let open Vdom_blit in
  let handler =
    {
      Cmd.f =
        (fun ctx -> function
          | Sync_wallet_cmd { callback } ->
              let () = Lwt.async (retreive_or_connect client ctx callback) in

              true
          | Unsync_wallet_cmd { callback } ->
              let () = Lwt.async (disconnect_wallet client ctx callback) in

              true
          | _ -> false)
    }
  in
  register @@ cmd handler

type message =
  | Connect_wallet
  | Disconnect_wallet
  | Wallet_connected of Beacon_js.Account_info.t
  | Wallet_disconnected

type model =
  | Not_synced
  | Synced of { account_info : Beacon_js.Account_info.t }

let update state = function
  | Connect_wallet ->
      Vdom.return state
        ~c:
          [
            sync_wallet ~callback:(fun account_info ->
                Wallet_connected account_info)
          ]
  | Disconnect_wallet ->
      Vdom.return state
        ~c:[ unsync_wallet ~callback:(fun () -> Wallet_disconnected) ]
  | Wallet_connected account_info -> Vdom.return @@ Synced { account_info }
  | Wallet_disconnected -> Vdom.return Not_synced

let init = Vdom.return Not_synced

let view =
  let open Vdom in
  let open Vdom_ui in
  function
  | Not_synced ->
      button ~a:[ onclick (fun _ -> Connect_wallet) ] [ text "connect wallet" ]
  | Synced { account_info } ->
      let x =
        Beacon_js.Account_info.(
          account_info.address ^ " - " ^ account_info.identifier)
      in
      div ~a:[]
        [
          div [ txt_span @@ "synced " ^ x ]
        ; div
            [
              button
                ~a:[ onclick (fun _ -> Disconnect_wallet) ]
                [ text "disconnect wallet" ]
            ]
        ]

let app = Vdom.app ~init ~view ~update ()

let mount container_id =
  match Js_browser.(Document.(get_element_by_id document container_id)) with
  | None ->
      let () = Console.(message error "Unable to find root node") in
      Lwt.return_unit
  | Some root ->
      let client = Beacon_js.DApp_client.make ~name:"transfer" () in
      let () = Js_browser.Element.remove_all_children root in
      let () = register client in
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
