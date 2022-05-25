open Yocaml

let poor_slug str =
  String.fold_left
    (fun acc chr ->
      let chr = Char.lowercase_ascii chr in
      let code = Char.code chr in
      if code >= 48 && code <= 57 then Format.asprintf "%s%c" acc chr
      else if code >= 97 && code <= 122 then Format.asprintf "%s%c" acc chr
      else if code = 32 || code = 45 then acc ^ "-"
      else acc)
    "" str

let remove_format elt =
  let rec aux acc = function
    | Omd.Text (_, value) | Code (_, value) -> acc ^ value
    | Html _ -> acc
    | Emph (_, inline) | Strong (_, inline) -> aux acc inline
    | Link (_, { label; _ }) | Image (_, { label; _ }) -> aux acc label
    | Hard_break _ | Soft_break _ -> "\n"
    | Concat (_, inlines) ->
        List.fold_left (fun acc inline -> aux acc inline) acc inlines
  in
  aux "" elt

let anchor attr label =
  let open Omd in
  let destination = "#" ^ (poor_slug $ remove_format label) in
  Paragraph (attr, Link ([], { label; destination; title = None }))

let rec map_list doc =
  let open Omd in
  List.map
    (List.map (function
      | Paragraph (x, label) -> anchor x label
      | List (attributes, list_type, list_spacing, inner_blocks) ->
          List (attributes, list_type, list_spacing, map_list inner_blocks)
      | x -> x))
    doc

and map_toc doc =
  let open Omd in
  List.map
    (function
      | List (attributes, list_type, list_spacing, inner_blocks) ->
          List (attributes, list_type, list_spacing, map_list inner_blocks)
      | x -> x)
    doc

let add_id doc =
  List.map
    (function
      | Omd.Heading (attributes, level, inline) ->
          let new_attributes =
            match List.assoc_opt "id" attributes with
            | None -> ("id", poor_slug $ remove_format inline) :: attributes
            | Some _ -> attributes
          in
          Omd.Heading (new_attributes, level, inline)
      | x -> x)
    doc

let doc_from_string = Build.arrow Omd.of_string

let doc_to_html_with_toc =
  Build.arrow (fun doc ->
      let toc = Omd.toc ~depth:5 doc in
      (Omd.to_html $ map_toc toc, Omd.to_html $ add_id doc))

let doc_to_html = Build.arrow Omd.to_html
let string_to_html = Build.(doc_from_string >>^ add_id >>> doc_to_html)
let string_to_html_with_toc = Build.(doc_from_string >>> doc_to_html_with_toc)
