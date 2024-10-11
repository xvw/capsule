module Parse = struct
  class type t = Model.Types.common

  let entity_name = "Page"
  let neutral = Yocaml.Metadata.required entity_name

  let validate =
    let open Yocaml.Data.Validation in
    record Model.Common.validate
  ;;
end

class type t = object
  inherit Parse.t
  inherit [Model.Config.t] Model.Types.with_configuration
  inherit Model.Types.with_target_path
  inherit Model.Types.with_source_path
end

class make p config source_path target_path =
  object (_ : #t)
    inherit
      Model.Common.t
        ~title:p#page_title
        ~charset:p#page_charset
        ~description:p#description
        ~breadcrumb:p#breadcrumb
        ~tags:p#tags
        ~display_toc:p#display_toc

    method configuration = config
    method source_path = source_path
    method target_path = target_path
  end

let configure config ~source ~target =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift (fun parsed -> new make parsed config source target))
;;

let table_of_contents page = page#with_toc

let normalize_build_info page =
  let open Yocaml.Data in
  let target = Yocaml.Path.relocate ~into:Yocaml.Path.root page#target_path in
  let config = page#configuration in
  let source = page#source_path in
  let repo = Model.Config.repository_of config in
  let branch = Model.Config.branch_of config in
  let external_resource = Model.Repo.resolve_path ~branch source repo in
  record
    [ ("self_url", Model.Url.(normalize (from_path target)))
    ; "repo_url", Model.Url.normalize external_resource
    ]
;;

let meta page = Model.Common.meta page

let normalize page =
  Model.Common.normalize page
  @ [ "config", Model.Config.normalize page#configuration
    ; "build_info", normalize_build_info page
    ; "meta", Model.Meta.normalize_options @@ meta page
    ]
;;
