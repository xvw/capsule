type status =
  | Unceasing
  | Work_in_progress
  | Done
  | Paused
  | Interrupted

type 'a project =
  { license : string option
  ; status : status
  ; repo : Model.Repo.t option
  ; releases : Model.Key_value.Links.t
  ; links : Model.Key_value.Links.t
  ; state : Kohai_model.State.t option
  ; page : 'a
  }

let make_title project_name project =
  let open Std.Option in
  Kohai_model.Described_item.name <$> project <|> project_name
;;

let make_synopsis project_name project =
  let open Std.Option in
  project
  >>= Kohai_model.Described_item.description
  <|> (Format.asprintf "Présentation du projet `%s`" <$> project_name)
;;

let empty_project ~activity_url ~project_name ~project () =
  let title = make_title project_name project in
  let synopsis = make_synopsis project_name project in
  { license = None
  ; status = Unceasing
  ; repo = None
  ; releases = Model.Key_value.Links.empty
  ; links = Model.Key_value.Links.empty
  ; page = Raw.Input.empty_project ~activity_url ?title ?synopsis ()
  ; state = None
  }
;;

let project_without_state ~activity_url ~project_name ~project input =
  let synopsis =
    let open Std.Option in
    project
    >>= Kohai_model.Described_item.description
    <|> (Format.asprintf "Présentation du projet `%s`" <$> project_name)
  in
  { input with
    page =
      (input.page#add_breadcrumb
         (Raw.Input.default_project_breadcrumb activity_url))
        #compute_synopsis
        synopsis
  }
;;

let project_without_content ~activity_url ~project_name ~project state =
  let title = make_title project_name project in
  let synopsis = make_synopsis project_name project in
  { license = None
  ; status = Unceasing
  ; repo = None
  ; releases = Model.Key_value.Links.empty
  ; links = Model.Key_value.Links.empty
  ; page =
      Raw.Input.empty_project
        ~with_notice:false
        ~activity_url
        ?title
        ?synopsis
        ()
  ; state = Some state
  }
  |> project_without_state ~activity_url ~project_name ~project
;;

let with_state state input = { input with state = Some state }

let project ~activity_url ~project_name ~project state input =
  input
  |> project_without_state ~activity_url ~project_name ~project
  |> with_state state
;;

module Input = struct
  type t = Raw.Input.t project

  let entity_name = "Project"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page; _ } = Raw.Input.to_entry ~file ~url page

  let status =
    let open Yocaml.Data.Validation in
    Yocaml.Slug.validate
    $ function
    | "work-in-progress" | "wip" | "w" | "in-progress" -> Work_in_progress
    | "done" | "finished" | "d" -> Done
    | "pause" | "paused" | "p" | "break" -> Paused
    | "interrupted" | "interrupt" | "stoped" -> Interrupted
    | _ -> Unceasing
  ;;

  let validate obj =
    let open Yocaml.Data.Validation in
    let* page = Raw.Input.validate obj in
    record
      (fun f ->
         let+ status = optional_or f ~default:Paused "status" status
         and+ license = optional f "license" string
         and+ repo = optional f "repository" Model.Repo.validate
         and+ releases =
           optional_or
             f
             ~default:Model.Key_value.Links.empty
             "releases"
             Model.Key_value.Links.validate
         and+ links =
           optional_or
             f
             ~default:Model.Key_value.Links.empty
             "links"
             Model.Key_value.Links.validate
         in
         { page; status; license; repo; releases; links; state = None })
      obj
  ;;
end

type t = Raw.Output.t project

let normalize_status s =
  Yocaml.Data.string
    (match s with
     | Work_in_progress -> "wip"
     | Unceasing -> "unceasing"
     | Done -> "done"
     | Paused -> "paused"
     | Interrupted -> "interrupted")
;;

let normalize { license; status; repo; releases; links; page; state } =
  Raw.Output.normalize page
  @ Yocaml.Data.
      [ "license", option string license
      ; "status", normalize_status status
      ; "repository", option Model.Repo.normalize repo
      ; "releases", Model.Key_value.Links.normalize releases
      ; "links", Model.Key_value.Links.normalize links
      ; "kohai_state", option Yocaml_kohai.State.normalize state
      ; "has_links", Model.Key_value.Links.has_elements links
      ; "has_releases", Model.Key_value.Links.has_elements releases
      ; "has_kohai_state", Model.Model_util.exists_from_opt state
      ]
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
     @@ fun ({ page; state; _ } as proj) ->
     let published_at =
       let open Std.Option in
       let* state = state in
       let+ d = Kohai_model.State.big_bang_of state in
       Yocaml_kohai.Datetime.to_yocaml d
     in
     let updated_at =
       let open Std.Option in
       let* state = state in
       let* d = published_at in
       let* e = Kohai_model.State.end_of_world_of state in
       let e = Yocaml_kohai.Datetime.to_yocaml e in
       if Yocaml.Datetime.equal d e then None else Some e
     in
     { proj with
       page =
         Raw.Output.full_configure
           ?published_at
           ?updated_at
           ~config
           ~source
           ~target
           ~kind
           ~on_synopsis
           page
     })
;;

let table_of_content ({ page; _ } as proj) s =
  { proj with page = Raw.Output.table_of_content page s }
;;
