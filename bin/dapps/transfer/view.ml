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

let amount_input_section balance (amount_value, _amount_tez, amount_valid) =
  let open Vdom in
  let open Vdom_html in
  let minimal_fee = Tezos_js.Tez.(to_string @@ Micro.from_int' 100) in
  let fast_fee = Tezos_js.Tez.(to_string @@ Micro.from_int' 150) in
  let rocket_fee = Tezos_js.Tez.(to_string @@ Micro.from_int' 200) in
  div
    ~a:[ class_ "transfer-fill-amount" ]
    [
      div
        ~a:[ class_ "transfer-input-amount" ]
        [
          tez_input ~min:Tezos_js.Tez.one ~max:balance ~step:Tezos_js.Tez.one
            ~a:
              [
                placeholder "Montant du transfert"
              ; value amount_value
              ; oninput Messages.input_amount_form
              ]
            ()
        ]
    ; div
        ~a:[ class_ "transfer-input-base-fee" ]
        [
          div
            [
              input
                ~a:
                  [
                    type_ "radio"
                  ; id "fee-minimal"
                  ; value minimal_fee
                  ; name "base-fee"
                  ; checked
                  ]
                []
            ; label ~a:[ for_ "fee-minimal" ] [ text minimal_fee ]
            ]
        ; div
            [
              input
                ~a:
                  [
                    type_ "radio"
                  ; id "fee-fast"
                  ; value fast_fee
                  ; name "base-fee"
                  ]
                []
            ; label ~a:[ for_ "fee-fast" ] [ text fast_fee ]
            ]
        ; div
            [
              input
                ~a:
                  [
                    type_ "radio"
                  ; id "fee-rocket"
                  ; value rocket_fee
                  ; name "base-fee"
                  ]
                []
            ; label ~a:[ for_ "fee-rocket" ] [ text rocket_fee ]
            ]
        ]
    ; div [ text (if amount_valid then "✔" else "✖") ]
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
  and amount_form = state.amount_form
  and head = state.head in
  div
    [
      connected_badge Messages.beacon_unsync account_info.address balance
    ; transfer_input_section state
    ; amount_input_section balance amount_form
    ; bottom_section account_info head
    ]

let state_view = function
  | Model.Not_sync -> not_sync_view
  | Model.Sync state -> sync_view state

let view model =
  Vdom_html.div @@ error_section model.Model.error @ [ state_view model.state ]
