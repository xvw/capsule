let from_log_set (module R : Intf.RESOLVER) set =
  let set = set |> Kohai_core.Uuid.Set.to_list |> List.map R.Source.Kohai.log in
  let open Yocaml.Eff in
  let+ logs =
    set
    |> Yocaml.Eff.List.traverse
         (Yocaml_rensai.Eff.read_file_as_metadata
            (module Yocaml_kohai.Log)
            ~on:`Source)
  in
  logs, Yocaml.Deps.from_list set
;;

let from_set (module R : Intf.RESOLVER) path =
  let open Yocaml.Task in
  Yocaml_rensai.Pipeline.read_file_as_metadata
    (module Yocaml_kohai.Uuid.Set)
    path
  >>* from_log_set (module R)
;;

let build_now_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      on_synopsis
      config
      target
  =
  let open Yocaml.Task in
  let source = R.Source.now in
  from_set (module R) R.Source.Kohai.last_logs
  &&& Yocaml.Pipeline.read_file_with_metadata
        (module P)
        (module Archetype.Activity_state.Input)
        source
  >>> Archetype.Activity_state.configure_from_logs
        ~config
        ~source
        ~target
        ~kind:Model.Types.Article
        ~on_synopsis
;;

let read_dir = Yocaml.Eff.read_directory ~on:`Source ~only:`Directories

let get_states p =
  let open Yocaml.Eff in
  List.traverse
    (fun p ->
       let key =
         Yocaml.Path.(p |> dirname |> basename)
         |> Option.value ~default:"unknown"
       in
       let+ state =
         Yocaml_rensai.Eff.read_file_as_metadata
           ~on:`Source
           (module Yocaml_kohai.State)
           p
       in
       key, state)
    p
;;

let collect_activity (module R : Intf.RESOLVER) =
  Yocaml.Task.from_effect ~has_dynamic_dependencies:true (fun () ->
    let open Yocaml.Eff in
    let* projects = read_dir R.Source.Kohai.projects in
    let* sectors = read_dir R.Source.Kohai.sectors in
    let projects = Stdlib.List.map R.Source.Kohai.state_of projects in
    let sectors = Stdlib.List.map R.Source.Kohai.state_of sectors in
    let* project_states = get_states projects in
    let+ sector_states = get_states sectors in
    let deps = Yocaml.Deps.(concat (from_list projects) (from_list sectors)) in
    project_states, sector_states, deps)
;;

let build_activity_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      on_synopsis
      config
      target
  =
  let open Yocaml.Task in
  let source = R.Source.activity in
  collect_activity (module R)
  &&& Yocaml.Pipeline.read_file_with_metadata
        (module P)
        (module Archetype.Activity_state.Input)
        source
  >>> Archetype.Activity_state.configure_from_states
        ~config
        ~source
        ~target
        ~kind:Model.Types.Article
        ~on_synopsis
;;

let layout_arrow (module R : Intf.RESOLVER) =
  let open Yocaml.Task in
  Dynamic.on_content (Yocaml_cmarkit.to_html ())
  >>> Layout.as_dynamic
        (module R)
        (module Archetype.Activity_state)
        [ "page.html"; "logs-summary.html"; "page-header.html"; "layout.html" ]
;;

let create_now_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      on_synopsis
      config
  =
  let target = R.Target.now in
  Yocaml.Action.Dynamic.write_file_with_metadata
    (R.Target.promote target)
    (let open Yocaml.Task in
     R.track_common_deps
     >>> build_now_page (module P) (module R) on_synopsis config target
     >>> layout_arrow (module R))
;;

let create_activity_page
      (module P : Yocaml.Required.DATA_PROVIDER)
      (module R : Intf.RESOLVER)
      on_synopsis
      config
  =
  let target = R.Target.activity in
  Yocaml.Action.Dynamic.write_file_with_metadata
    (R.Target.promote target)
    (let open Yocaml.Task in
     R.track_common_deps
     >>> build_activity_page (module P) (module R) on_synopsis config target
     >>> layout_arrow (module R))
;;
