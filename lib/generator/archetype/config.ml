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
  ; journal_entries_per_page : int
  ; kohai_state : Kohai_model.State.t option
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
    and+ svg = optional_or ~default:[] bag "svg" (list_of Model.Svg.validate)
    and+ journal_entries_per_page =
      optional_or ~default:4 bag "journal_entries_per_page" (int & gt 0)
    in
    { title
    ; repository
    ; branch
    ; software_license
    ; content_license
    ; owner
    ; svg
    ; default_cover
    ; main_url
    ; journal_entries_per_page
    ; kohai_state = None
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
      ; journal_entries_per_page
      ; kohai_state
      }
  =
  let open Yocaml.Data in
  record
    [ "main_title", string title
    ; "main_url", Model.Url.normalize main_url
    ; "kohai_state", option Yocaml_kohai.State.normalize kohai_state
    ; "repository", Model.Repo.normalize repository
    ; "branch", string branch
    ; "journal_entries_per_page", int journal_entries_per_page
    ; "software_license", Model.Link.normalize software_license
    ; "content_license", Model.Link.normalize content_license
    ; "owner", Model.Identity.normalize owner
    ; "svg", Model.Svg.normalize_list svg
    ; "default_cover", option Model.Cover.normalize default_cover
    ; "has_default_cover", Model.Model_util.exists_from_opt default_cover
    ; "has_kohai_state", Model.Model_util.exists_from_opt kohai_state
    ]
;;

let repository_of { repository; _ } = repository
let branch_of { branch; _ } = branch
let owner_of { owner; _ } = owner
let main_url_of { main_url; _ } = main_url
let default_cover_of { default_cover; _ } = default_cover

let journal_entries_per_page { journal_entries_per_page; _ } =
  journal_entries_per_page
;;

let resolve_cover config cover =
  Option.map (Model.Cover.resolve (main_url_of config)) cover
;;

let merge_kohai_state config state =
  let state =
    match Kohai_model.State.big_bang_of state with
    | Some _ -> Some state
    | None -> None
  in
  { config with kohai_state = state }
;;

let kohai_state { kohai_state; _ } =
  match kohai_state with
  | Some ks -> ks
  | None -> Kohai_model.State.big_bang ()
;;
