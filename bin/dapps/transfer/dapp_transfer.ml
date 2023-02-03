open Js_of_ocaml
open Core_js

let network = Tezos_js.Network.Nodes.Ghostnet.ecadlabs
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
        let open Tezos_js in
        let input =
          Estimation.make_input
            ~base_fee:(Tez.Micro.from_int' 10000)
            ~gas_limit:(Z.of_int 1101) ~storage_limit:Z.zero
            ~operation_size:(Z.of_int 162) ()
        in
        let r = Estimation.compute input in
        Console.(message log) (Format.asprintf "%a" Estimation.pp_output r)
      in
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
