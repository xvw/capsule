open Js_of_ocaml

let cheat_with_string_document str =
  let tpl = Dom_html.document##createElement (Js.string "div") in
  let () = tpl##.innerHTML := Js.string str in
  tpl##.innerText |> Js.to_string

type node_content =
  | Link of string * string
  | Text of string
  | Paragraph of node_content list

let parse_mastodon_response str =
  let tpl = Dom_html.document##createElement (Js.string "div") in
  let () = tpl##.innerHTML := Js.string str in
  let open Nightmare_js.Nullable in
  let rec aux acc = function
    | [] -> acc
    | node :: xs -> (
        let element =
          node |> Dom.CoerceTo.element >|= Dom_html.element |> to_option
        in
        match element with
        | None -> (
            match node |> Dom.CoerceTo.text |> to_option with
            | None -> aux acc xs
            | Some txt ->
                let str = txt##.data |> Js.to_string in
                let e = Text str in
                aux (e :: acc) xs)
        | Some elt -> (
            match elt |> Dom_html.CoerceTo.a |> to_option with
            | Some a ->
                let href = a##.href |> Js.to_string
                and value = a##.innerText |> Js.to_string in
                let e = Link (href, value) in
                aux (e :: acc) xs
            | None -> (
                match elt |> Dom_html.CoerceTo.p |> to_option with
                | Some p ->
                    let children = p##.childNodes |> Dom.list_of_nodeList in
                    let result = aux [] children in
                    let e = Paragraph (List.rev result) in
                    aux (e :: acc) xs
                | None ->
                    let children = elt##.childNodes |> Dom.list_of_nodeList in
                    let result = aux acc children in
                    aux result xs)))
  in
  let children = tpl##.childNodes |> Dom.list_of_nodeList in
  aux [] children |> List.rev
