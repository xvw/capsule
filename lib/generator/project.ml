let as_option ~path arr =
  let open Yocaml.Task in
  when_ (Yocaml.Pipeline.file_exists path) (arr >>| Option.some) (const None)
;;

let get_state (module R : Intf.RESOLVER) project =
  let state = R.Source.Kohai.Project.state_of project in
  as_option
    ~path:state
    (Yocaml_rensai.Pipeline.read_file_as_metadata
       (module Yocaml_kohai.State)
       state)
;;

let get_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      project
  =
  let page = R.Source.Kohai.Project.page_of project in
  as_option
    ~path:page
    (Yocaml.Pipeline.read_file_with_metadata
       (module P)
       (module Archetype.Project.Input)
       page)
;;

let collapse (module R : Intf.RESOLVER) project_name project result =
  match result with
  | None, None ->
    (* Should never happen. *)
    Archetype.Project.empty_project ~project_name ~project (), ""
  | None, Some (meta, content) ->
    Archetype.Project.project_without_state ~project_name ~project meta, content
  | Some state, None ->
    Archetype.Project.project_without_content ~project_name ~project state, ""
  | Some state, Some (meta, content) ->
    Archetype.Project.project ~project_name ~project state meta, content
;;

let get
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      projects
      project
  =
  let project_name = Yocaml.Path.basename project in
  let project_item =
    Option.bind project_name (fun key ->
      Kohai_model.Described_item.Set.find key projects)
  in
  let open Yocaml.Task in
  Yocaml.Pipeline.track_file R.Source.Kohai.Project.list
  >>> get_state (module R) project
  &&& get_page (module P) (module R) project
  >>| collapse (module R) project_name project_item
;;

let layout_arrow (module R : Intf.RESOLVER) =
  let open Yocaml.Task in
  Markdown.content_to_html_with_toc
    ~strict:false
    Archetype.Project.table_of_content
  >>> Layout.as_static
        (module R)
        (module Archetype.Project)
        [ "page.html"; "page-header.html"; "layout.html" ]
;;

let create_project_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      on_synopsis
      config
      projects
      project
  =
  let target = R.Target.project project in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    (let open Yocaml.Task in
     R.track_common_deps
     >>> get (module P) (module R) projects project
     >>> Archetype.Project.full_configure
           ~config
           ~source:project
           ~target
           ~kind:Model.Types.Article
           ~on_synopsis
     >>> layout_arrow (module R))
;;
