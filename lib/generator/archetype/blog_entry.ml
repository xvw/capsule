type t =
  { title : string
  ; date : Yocaml.Datetime.t
  ; synopsis : string option
  ; tags : string list
  }

let make ?date ~title ?synopsis ?(tags = []) () =
  let date = Std.Option.(date || Yocaml.Datetime.dummy) in
  { title; date; synopsis; tags }
;;

let normalize { title; date; synopsis; tags } =
  let open Yocaml.Data in
  record
    [ "title", string title
    ; "publication_date", Yocaml.Datetime.normalize date
    ; "synopsis", option string synopsis
    ; "tags", list_of string tags
    ; "has_synopsis", Model.Model_util.exists_from_opt synopsis
    ; "has_tags", Model.Model_util.exists_from_list tags
    ]
;;
