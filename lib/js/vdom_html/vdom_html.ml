let text = Vdom.text
let div = Vdom.div
let input = Vdom.input
let span ?key ?a l = Vdom.elt "span" ?key ?a l
let button ?key ?a l = Vdom.elt "button" ?key ?a l
let label ?key ?a l = Vdom.elt "label" ?key ?a l

let tez_input ?key ?(a = []) ~min ~max ~step () =
  let a =
    Vdom.
      [
        type_ "number"
      ; Property ("min", String (Tezos_js.Tez.to_string min))
      ; Property ("max", String (Tezos_js.Tez.to_string max))
      ; Property ("step", String (Tezos_js.Tez.to_string step))
      ]
    @ a
  in
  Vdom.input ?key ~a []

let placeholder x = Vdom.Property ("placeholder", String x)
let name x = Vdom.Property ("name", String x)
let id x = Vdom.Property ("id", String x)
let for_ x = Vdom.Property ("for", String x)
let checked = Vdom.Property ("checked", String "checked")
