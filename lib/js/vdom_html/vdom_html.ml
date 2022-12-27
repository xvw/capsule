let text = Vdom.text
let div = Vdom.div
let input = Vdom.input
let span ?key ?a l = Vdom.elt "span" ?key ?a l
let button ?key ?a l = Vdom.elt "button" ?key ?a l
let placeholder x = Vdom.Property ("placeholder", String x)
