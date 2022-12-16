open Js_of_ocaml

type 'message Vdom.Cmd.t +=
  | (* | Beacon_get_active_account_cmd of { *)
    (*       when_done : Beacon.AccountInfo.t option -> 'message *)
    (*   } *)
      Beacon_request_permissions_cmd of {
        when_done : Beacon.PermissionResponseOutput.t -> 'message
    }

(* let beacon_get_active_account ~when_done = *)
(*   Beacon_get_active_account_cmd { when_done } *)

let beacon_request_permissions ~when_done =
  Beacon_request_permissions_cmd { when_done }

let register client =
  let open Vdom_blit in
  let handler =
    {
      Cmd.f =
        (fun ctx -> function
          (* | Beacon_get_active_account_cmd { when_done } -> *)
          (*     let _ = *)
          (*       let open Lwt.Syntax in *)
          (*       let+ active_account = *)
          (*         Beacon.DAppClient.get_active_account client *)
          (*       in *)
          (*       Vdom_blit.Cmd.send_msg ctx (when_done active_account) *)
          (*     in *)
          (*     true *)
          | Beacon_request_permissions_cmd { when_done } ->
              let () =
                Lwt.async (fun () ->
                    let open Lwt.Syntax in
                    let+ result =
                      Beacon.DAppClient.request_permissions client
                    in
                    Vdom_blit.Cmd.send_msg ctx (when_done result))
              in
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
            beacon_request_permissions
              ~when_done:(fun
                           Beacon.PermissionResponseOutput.{ account_info; _ }
                         ->
                let () = Console.log "test" in
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
  | Synced _ -> txt_span "synced"

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
