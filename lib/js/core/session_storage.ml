open Js_of_ocaml

include Gen.Storage (struct
  let storage = Dom_html.window##.sessionStorage
end)
