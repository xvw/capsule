type t =
  { title : string
  ; repository : Model.Repo.t
  ; branch : string
  ; software_license : Model.Link.t
  ; content_license : Model.Link.t
  ; owner : Model.Identity.t
  ; svg : Model.Svg.t list
  }

let entity_name = "Configuration"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun bag ->
    let+ title = required bag "title" string
    and+ repository = required bag "repository" Model.Repo.validate
    and+ branch = optional_or ~default:"main" bag "branch" string
    and+ software_license = required bag "software_license" Model.Link.validate
    and+ content_license = required bag "content_license" Model.Link.validate
    and+ owner = required bag "owner" Model.Identity.validate
    and+ svg = optional_or ~default:[] bag "svg" (list_of Model.Svg.validate) in
    { title; repository; branch; software_license; content_license; owner; svg })
;;

let normalize
  { title; repository; branch; software_license; content_license; owner; svg }
  =
  let open Yocaml.Data in
  record
    [ "main_title", string title
    ; "repository", Model.Repo.normalize repository
    ; "branch", string branch
    ; "software_license", Model.Link.normalize software_license
    ; "content_license", Model.Link.normalize content_license
    ; "owner", Model.Identity.normalize owner
    ; "svg", Model.Svg.normalize_list svg
    ]
;;

let repository_of { repository; _ } = repository
let branch_of { branch; _ } = branch
