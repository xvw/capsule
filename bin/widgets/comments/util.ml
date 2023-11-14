open Js_of_ocaml

let cheat_with_string_document str =
  let tpl = Dom_html.document##createElement (Js.string "div") in
  let () = tpl##.innerHTML := Js.string str in
  tpl##.innerText |> Js.to_string
