open Model_util

type t =
  { name : string
  ; id : string
  ; synopsis : string option
  ; links : Link.t list
  }

let sort_by links = function
  | None -> links
  | Some Sort.{ key; rev } ->
    let links =
      match key with
      | "link-title" | "link-name" | "name" | "title" ->
        List.sort
          (fun a b ->
            let f = if rev then -1 else 1 in
            f * Link.compare_title a b)
          links
      | _ -> if rev then List.rev links else links
    in
    links
;;

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let* name = required fields "name" string in
    let+ id =
      optional_or
        ~default:(Yocaml.Slug.from name)
        fields
        "id"
        Yocaml.Slug.validate
    and+ synopsis = optional fields "synopsis" string
    and+ links = optional_or ~default:[] fields "links" (list_of Link.validate)
    and+ sort = optional fields "sort" Sort.validate in
    { name; id; synopsis; links = sort_by links sort })
;;

let normalize { name; id; synopsis; links } =
  let open Yocaml.Data in
  record
    [ "name", string name
    ; "id", string id
    ; "synopsis", option string synopsis
    ; "links", list_of Link.normalize links
    ; "has_synopsis", exists_from_opt synopsis
    ]
;;

let compare_by_name { name = name_a; _ } { name = name_b; _ } =
  String.compare name_a name_b
;;

let compare_by_id { id = id_a; _ } { id = id_b; _ } = String.compare id_a id_b