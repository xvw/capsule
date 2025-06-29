type t =
  { title : string
  ; date : Yocaml.Datetime.t
  ; synopsis : string option
  ; tags : string list
  ; path : Yocaml.Path.t
  }

let compare { date = a; _ } { date = b; _ } = Yocaml.Datetime.compare a b

let make ?date ~title ?synopsis ?(tags = []) path =
  let date = Std.Option.(date || Yocaml.Datetime.dummy) in
  { title; date; synopsis; tags; path }
;;

let normalize { title; date; synopsis; tags; path = p } =
  let open Yocaml.Data in
  record
    [ "title", string title
    ; "publication_date", Yocaml.Datetime.normalize date
    ; "synopsis", option string synopsis
    ; "tags", list_of string tags
    ; "path", path p
    ; "has_synopsis", Model.Model_util.exists_from_opt synopsis
    ; "has_tags", Model.Model_util.exists_from_list tags
    ]
;;

let sort ?(desc = true) list =
  let cmp = if desc then fun x y -> compare y x else compare in
  List.sort cmp list
;;
