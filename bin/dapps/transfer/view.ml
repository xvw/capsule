open Core_js

let error_section = function
  | None -> []
  | Some x ->
      let open Vdom in
      let open Vdom_html in
      [ div ~a:[ class_ "errors" ] [ text x ] ]

let not_sync_view =
  let open Vdom in
  let open Vdom_html in
  div
    ~a:[ class_ "not-connected" ]
    [
      button
        ~a:[ onclick Messages.beacon_sync; class_ "connection-button" ]
        [ text "connect wallet" ]
    ]

let connected_badge handler address balance =
  let open Vdom in
  let open Vdom_html in
  div
    ~a:[ class_ "connected-badge" ]
    [
      div
        ~a:[ class_ "tez" ]
        [ text @@ Format.asprintf "%a" Tezos_js.Tez.pp balance ]
    ; div ~a:[ class_ "address" ] [ text address ]
    ; div
        ~a:[ class_ "disconnection" ]
        [ button ~a:[ onclick handler ] [ text "Déconnexion" ] ]
    ]

let bottom_section account_info head =
  let open Vdom in
  let open Vdom_html in
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
               (fun () -> "Récupèration de la tête de la chaine...")
               (fun x ->
                 Tezos_js.Address.to_short_string x.Tezos_js.Monitored_head.hash)
               head)
        ]
    ]

let transfer_input_section state =
  let open Vdom in
  let open Vdom_html in
  let inputed_address, is_valid_address = Model.get_address state in
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
              ; oninput Messages.input_address_form
              ]
            []
        ]
    ; div [ text (if is_valid_address then "✔" else "✖") ]
    ]

let sync_view state =
  let open Vdom_html in
  let account_info = state.Model.account_info
  and balance = state.balance
  and head = state.head in
  div
    [
      connected_badge Messages.beacon_unsync account_info.address balance
    ; transfer_input_section state
    ; bottom_section account_info head
    ]

let state_view = function
  | Model.Not_sync -> not_sync_view
  | Model.Sync state -> sync_view state

let view model =
  Vdom_html.div @@ error_section model.Model.error @ [ state_view model.state ]
