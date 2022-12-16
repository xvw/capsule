open Js_of_ocaml

type 'message Vdom.Cmd.t +=
  | Sync_wallet_cmd of { callback : Beacon.AccountInfo.t -> 'message }

let sync_wallet ~callback = Sync_wallet_cmd { callback }

let retreive_or_connect client ctx callback () =
  let open Lwt.Syntax in
  let* potential_active_account = Beacon.DAppClient.get_active_account client in
  let+ active_info =
    match potential_active_account with
    | Some active_info -> Lwt.return active_info
    | None ->
        let+ Beacon.PermissionResponseOutput.{ account_info; _ } =
          Beacon.DAppClient.request_permissions client
        in

        account_info
  in
  Vdom_blit.Cmd.send_msg ctx (callback active_info)

let register client =
  let open Vdom_blit in
  let handler =
    {
      Cmd.f =
        (fun ctx -> function
          | Sync_wallet_cmd { callback } ->
              let () = Lwt.async (retreive_or_connect client ctx callback) in
              true
          | _ -> false)
    }
  in
  register @@ cmd handler

type message = Connect_wallet | Wallet_connected of Beacon.AccountInfo.t
type model = Not_synced | Synced of { account_info : Beacon.AccountInfo.t }

let update state = function
  | Connect_wallet ->
      Vdom.return state
        ~c:
          [
            sync_wallet ~callback:(fun account_info ->
                Wallet_connected account_info)
          ]
  | Wallet_connected account_info -> Vdom.return @@ Synced { account_info }

let init = Vdom.return Not_synced

let view =
  let open Vdom in
  function
  | Not_synced ->
      input
        ~a:
          [
            onclick (fun _ -> Connect_wallet)
          ; value "connect wallet"
          ; type_button
          ]
        []
  | Synced { account_info } ->
      let x =
        Beacon.AccountInfo.(
          account_info.address ^ " - " ^ account_info.identifier)
      in
      txt_span @@ "synced " ^ x

let app = Vdom.app ~init ~view ~update ()

let mount container_id =
  match Js_browser.(Document.(get_element_by_id document container_id)) with
  | None ->
      let () = Console.(message error "Unable to find root node") in
      Lwt.return_unit
  | Some root ->
      let client = Beacon.DAppClient.make ~name:"transfer" () in
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
