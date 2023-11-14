let render_ctx _model ctx =
  let open Nightmare_js_vdom in
  let open Mastodon in
  div
    (List.map
       (fun status -> p [ txt @@ status.Status.content ])
       ctx.Context.descendants)

let view model =
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "dapp-container" ] ]
    [
      (match model.Model.state with
      | Loading ->
          div
            ~a:[ a_class [ "dapp-loading" ] ]
            [ span [ txt "❖" ]; span [ txt "Chargement des commentaires" ] ]
      | Failed -> div [ txt "Impossible de récupérer les commentaires" ]
      | Fetched context -> render_ctx model context)
    ]
