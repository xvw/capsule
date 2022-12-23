let text = Vdom.text
let div = Vdom.div
let input = Vdom.input
let span ?key ?a l = Vdom.elt "span" ?key ?a l
let button ?key ?a l = Vdom.elt "button" ?key ?a l

let connected_badge handler address balance =
  let open Vdom in
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

let placeholder x = Vdom.Property ("placeholder", String x)
