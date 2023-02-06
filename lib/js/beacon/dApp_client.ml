open Js_of_ocaml
open Core_js

type t = Bindings.dAppClient Js.t
type constr = (Bindings.dAppClientOptions Js.t -> t) Js.constr

let make ?icon_url ?app_url ?matrix_nodes ?preferred_network ~name () =
  let options =
    let open Undefinedable in
    object%js
      val name = Js.string name
      val iconUrl = Js.string <$> from_option icon_url
      val appUrl = Js.string <$> from_option app_url

      val preferredNetwork =
        Js.string % Tezos_js.Network.to_string <$> from_option preferred_network

      val matrixNodes = list_to_js_array Js.string <$> from_option matrix_nodes
    end
  in
  let constr : constr = Js.Unsafe.global##._DAppClient in
  new%js constr options

let request_permissions ?network ?scopes client =
  let options =
    let open Undefinedable in
    object%js
      val network = Network.to_js <$> from_option network
      val scopes = Permission_scope.to_js_array <$> from_option scopes
    end
  in
  let open Lwt.Infix in
  as_lwt @@ client##requestPermissions options
  >|= Permission_response_output.from_js

let request_transfer ~destination ~amount client =
  let details =
    object%js
      val kind = Tezos_js.Operation_type.(TRANSACTION |> to_string |> Js.string)
      val destination = Tezos_js.Address.(destination |> to_string |> Js.string)
      val amount = Tezos_js.Tez.Micro.to_string amount |> Js.string
    end
  in
  let input =
    object%js
      val operationDetails = Js.array [| details |]
    end
  in
  let open Lwt.Infix in
  as_lwt @@ client##requestOperation input >|= fun r ->
  let _ = Console.log r in
  ()

let get_active_account client =
  let open Lwt.Infix in
  as_lwt @@ client##getActiveAccount
  >|= Option.(Functor.map Account_info.from_js % from_undefinedable)

let clear_active_account client = as_lwt @@ client##clearActiveAccount
let disconnect_wallet client = clear_active_account client
let get_block_explorer client = client##.blockExplorer
