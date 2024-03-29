let loading () =
  let open Nightmare_js_vdom in
  [
    div
      ~a:[ a_class [ "dapp-loading" ] ]
      [ span [ txt "❖" ]; span [ txt "En attente" ] ]
  ]

let not_synced () =
  let open Nightmare_js_vdom in
  [
    div
      ~a:[ a_class [ "centered"; "clickable" ]; on_click Message.ask_for_sync ]
      [ txt "Synchroniser le Wallet" ]
  ]

let render_current_block =
  let open Nightmare_js_vdom in
  function
  | None -> [ txt "■ chargement de la tête" ]
  | Some head ->
      let hash = head.Yourbones.Block_header.hash in
      [ txt @@ "■ " ^ Dapps.Util.block_hash_to_string hash ]

let synced_header balance head =
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "dapp-std-header" ] ]
    [
      div ~a:[ a_class [ "current-block" ] ] (render_current_block head)
    ; div
        ~a:[ a_class [ "current-balance" ] ]
        [ txt @@ Format.asprintf "⛃ %a" Yourbones.Tez.pp_print balance ]
    ; div
        ~a:[ a_class [ "disconnect" ] ]
        [ span ~a:[ on_click Message.ask_for_unsync ] [ txt "⏻ Quitter" ] ]
    ]

let sending_form user_address benefactor_inputable =
  let is_valid = Dapps.Inputable.is_valid benefactor_inputable in

  let focus_class = if is_valid then "valid" else "invalid" in
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "transfer-form-grid" ] ]
    [
      div
        ~a:[ a_class [ "owner-address" ] ]
        [ txt @@ Yourbones.Address.to_string user_address ]
    ; div
        ~a:[ a_class [ "benefactor-address" ] ]
        [
          input
            ~a:
              [
                on_input Message.fill_benefactor_adress
              ; a_placeholder "Addresse du bénéficiaire"
              ; a_value @@ Dapps.Inputable.get_value benefactor_inputable
              ; a_class [ focus_class ]
              ]
            ()
        ]
    ]

let xtz_amount balance target_inputable amount_inputable =
  let is_valid = Dapps.Inputable.is_valid amount_inputable in
  let is_addr_valid = Dapps.Inputable.is_valid target_inputable in

  let focus_class = if is_valid then "valid" else "invalid" in
  let max = `Datetime Yourbones.Tez.(Format.asprintf "%a" (pp ()) balance) in

  let open Nightmare_js_vdom in
  let btn_attr =
    if is_valid && is_addr_valid then
      [ a_disabled false; on_click Message.transfer ]
    else [ a_disabled true ]
  in
  div
    ~a:[ a_class [ "transfer-form-xtz" ] ]
    [
      div
        [
          input
            ~a:
              [
                on_input Message.fill_amount
              ; a_input_type `Text
              ; a_input_min (`Datetime "0.50000")
              ; a_input_max max
              ; a_step 0.5
              ; a_placeholder "montant du transfert"
              ; a_class [ focus_class ]
              ]
            ()
        ]
    ; div [ button ~a:btn_attr [ txt "Effectuer le transfert" ] ]
    ]

let synced state =
  [
    synced_header state.Model.balance state.Model.head
  ; sending_form state.Model.account.address state.Model.benefactor_address
  ; xtz_amount state.Model.balance state.Model.benefactor_address
      state.Model.amount
  ]

let render_trace =
  let open Nightmare_js_vdom in
  function
  | Model.Error message -> li ~a:[ a_class [ "error" ] ] [ txt message ]
  | Model.Pending message -> li ~a:[ a_class [ "pending" ] ] [ txt message ]
  | Model.Done message -> li ~a:[ a_class [ "trace" ] ] [ txt message ]

let render_footer trace =
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "dapp-footer" ] ]
    (match trace with [] -> [] | _ -> [ ul (List.map render_trace trace) ])

let view Model.{ trace; state } =
  Nightmare_js_vdom.(
    div
      ~a:[ a_class [ "black-dapp" ] ]
      [
        div
          ~a:[ a_class [ "dapp-content" ] ]
          (match state with
          | Model.Not_synced -> not_synced ()
          | Model.Loading | Model.Await_inclusion _ -> loading ()
          | Model.Synced state -> synced state)
      ; render_footer trace
      ])
