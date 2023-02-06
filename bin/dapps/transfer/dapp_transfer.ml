open Js_of_ocaml
open Core_js

let network = Tezos_js.Network.Nodes.Mainnet.ecadlabs
let name = "Transfer"

let mount container_id =
  match Js_browser.(Document.(get_element_by_id document container_id)) with
  | None ->
      let () = Console.(message error) "Unable to find root node" in
      Lwt.return_unit
  | Some root ->
      let open Lwt_util in
      let client = Beacon_js.Client.make ~network ~name () in
      let* init = Model.init client in
      let update = Model.update in
      let view = View.view in
      let app = Vdom.app ~init ~view ~update () in
      let () = Commands.register client in
      let () = Js_browser.Element.remove_all_children root in
      let () =
        Vdom_blit.run app
        |> Vdom_blit.dom
        |> Js_browser.Element.append_child root
      in
      Lwt.return_unit

let entrypoint =
  object%js
    method mount input =
      let container_id = Js.to_string input##.containerId in
      mount container_id
  end
