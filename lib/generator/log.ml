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
        (module Archetype.Logset.Input)
        source
  >>> Archetype.Logset.full_configure
        ~config
        ~source
        ~target
        ~kind:Model.Types.Article
        ~on_synopsis
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
     >>> Yocaml.Task.Dynamic.on_content (Yocaml_cmarkit.to_html ())
     >>> Yocaml.Task.Dynamic.on_static
           (Yocaml_jingoo.Pipeline.as_template
              (module Archetype.Logset)
              (R.Source.template "page.html"))
     >>> Yocaml.Task.Dynamic.on_static
           (Yocaml_jingoo.Pipeline.as_template
              (module Archetype.Logset)
              (R.Source.template "logs-summary.html"))
     >>> Yocaml.Task.Dynamic.on_static
           (Yocaml_jingoo.Pipeline.as_template
              (module Archetype.Logset)
              (R.Source.template "page-header.html"))
     >>> Yocaml.Task.Dynamic.on_static
           (Yocaml_jingoo.Pipeline.as_template
              (module Archetype.Logset)
              (R.Source.template "layout.html")))
;;
