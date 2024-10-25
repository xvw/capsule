type t =
  { title : string
  ; content_url : Yocaml.Path.t
  ; datetime : Yocaml.Datetime.t
  ; summary : string option
  ; tags : string list
  ; file : Yocaml.Path.t
  }

let make ~title ~content_url ~datetime ?summary ~tags ~file () =
  { title; content_url; datetime; summary; tags; file }
;;

let compare a b = Yocaml.Datetime.compare a.datetime b.datetime
let rev_compare b a = compare a b

let to_atom ~base_url { title; content_url; datetime; summary; tags; _ } =
  let open Yocaml_syndication in
  let path = Url.from_path content_url in
  let id = Url.resolve base_url path |> Url.to_string in
  let links = [ Atom.alternate ~title id ] in
  let summary = Option.map Atom.text summary in
  let categories = List.map Category.make tags in
  let updated = Datetime.make datetime in
  let title = Atom.text title in
  Atom.entry ?summary ~links ~categories ~updated ~id ~title ()
;;

let tags_of { tags; _ } = tags
let file_of { file; _ } = file
