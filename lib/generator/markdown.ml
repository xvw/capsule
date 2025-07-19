let tm =
  let t = TmLanguage.create () in
  let () =
    [ Hilite.Grammars.ocaml
    ; Hilite.Grammars.ocaml_interface
    ; Hilite.Grammars.dune
    ; Hilite.Grammars.opam
    ; Hilite.Grammars.diff
    ]
    |> List.iter (fun g ->
      g |> TmLanguage.of_yojson_exn |> TmLanguage.add_grammar t)
  in
  t
;;

let of_doc ?(safe = true) content =
  content
  |> Hilite_markdown.transform ~skip_unknown_languages:true ~tm
  |> Cmarkit_html.of_doc ~safe
;;

let string_to_html ?strict ?safe content =
  content |> Cmarkit.Doc.of_string ?strict |> of_doc ?safe
;;

let to_html ?(strict = true) ?(safe = false) () =
  Yocaml.Task.lift (fun content ->
    content
    |> Cmarkit.Doc.of_string ~heading_auto_ids:true ~strict
    |> of_doc ~safe)
;;

let to_html_with_toc ?(strict = true) ?(safe = false) () =
  let open Yocaml.Task in
  Yocaml_cmarkit.to_doc ~strict ()
  >>> Yocaml_cmarkit.table_of_contents
  >>> second (lift @@ of_doc ~safe)
;;

let content_to_html_with_toc ?strict ?safe f =
  let open Yocaml.Task in
  second (to_html_with_toc ?strict ?safe ())
  >>| fun (meta, (toc, doc)) -> f meta toc, doc
;;

let content_to_html ?strict ?safe () =
  Yocaml.Task.second (to_html ?strict ?safe ())
;;
