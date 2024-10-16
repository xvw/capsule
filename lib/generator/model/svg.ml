open Model_util

type t =
  { key : string
  ; role : string
  ; viewbox : string
  ; xmlns : string
  ; title : string option
  ; content : string
  }

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ key = required fields "key" Yocaml.Slug.validate
    and+ role = optional_or ~default:"img" fields "role" string
    and+ viewbox = optional_or ~default:"0 0 24 24" fields "viewbox" string
    and+ xmlns =
      optional_or ~default:"http://www.w3.org/2000/svg" fields "xmlns" string
    and+ title = optional fields "title" string
    and+ content = required fields "content" string in
    { key; role; viewbox; xmlns; title; content })
;;

let to_html { role; viewbox; xmlns; title; content; _ } =
  let title =
    match title with
    | None -> ""
    | Some x -> "<title>" ^ x ^ "</title>"
  in
  Format.asprintf
    {|<svg role="%s" viewBox="%s" xmlns="%s">%s%s</svg>|}
    role
    viewbox
    xmlns
    title
    content
;;

let normalize ({ role; viewbox; xmlns; title; content; key } as svg) =
  let open Yocaml.Data in
  record
    [ "key", string key
    ; "role", string role
    ; "viewbox", string viewbox
    ; "xmlns", string xmlns
    ; "title", option string title
    ; "content", string content
    ; "has_title", exists_from_opt title
    ; "to_html", string @@ to_html svg
    ]
;;

let normalize_list l =
  let open Yocaml.Data in
  record (List.map (fun svg -> svg.key, normalize svg) l)
;;
