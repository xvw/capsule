type t =
  { title : string
  ; repository : Model.Repo.t
  ; main_url : Model.Url.t
  ; branch : string
  ; default_cover : Model.Cover.t option
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
    and+ main_url = required bag "main_url" Model.Url.validate
    and+ repository = required bag "repository" Model.Repo.validate
    and+ branch = optional_or ~default:"main" bag "branch" string
    and+ software_license = required bag "software_license" Model.Link.validate
    and+ content_license = required bag "content_license" Model.Link.validate
    and+ owner = required bag "owner" Model.Identity.validate
    and+ default_cover = optional bag "default_cover" Model.Cover.validate
    and+ svg = optional_or ~default:[] bag "svg" (list_of Model.Svg.validate) in
    { title
    ; repository
    ; branch
    ; software_license
    ; content_license
    ; owner
    ; svg
    ; default_cover
    ; main_url
    })
;;

let normalize
  { title
  ; repository
  ; branch
  ; software_license
  ; content_license
  ; owner
  ; svg
  ; main_url
  ; default_cover
  }
  =
  let open Yocaml.Data in
  record
    [ "main_title", string title
    ; "main_url", Model.Url.normalize main_url
    ; "repository", Model.Repo.normalize repository
    ; "branch", string branch
    ; "software_license", Model.Link.normalize software_license
    ; "content_license", Model.Link.normalize content_license
    ; "owner", Model.Identity.normalize owner
    ; "svg", Model.Svg.normalize_list svg
    ; "default_cover", option Model.Cover.normalize default_cover
    ; "has_default_cover", Model.Model_util.exists_from_opt default_cover
    ]
;;

let repository_of { repository; _ } = repository
let branch_of { branch; _ } = branch
let owner_of { owner; _ } = owner
let main_url_of { main_url; _ } = main_url
let default_cover_of { default_cover; _ } = default_cover

let resolve_cover config cover =
  Option.map (Model.Cover.resolve (main_url_of config)) cover
;;
