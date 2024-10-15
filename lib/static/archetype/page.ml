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
  inherit [Config.t] Model.Types.with_configuration
  inherit Model.Types.with_target_path
  inherit Model.Types.with_source_path
end

class make p config source_path target_path =
  object (_ : #t)
    inherit
      Model.Common.t
        ~title:p#page_title
        ~document_kind:p#document_kind
        ~section:p#section
        ~charset:p#page_charset
        ~description:p#description
        ~synopsis:p#synopsis
        ~published_at:p#published_at
        ~updated_at:p#updated_at
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

let on_synopsis f =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift (fun metadata -> metadata#on_synopsis f))
;;

let normalize_build_info page =
  let open Yocaml.Data in
  let target = Yocaml.Path.relocate ~into:Yocaml.Path.root page#target_path in
  let config = page#configuration in
  let source = page#source_path in
  let repo = Config.repository_of config in
  let branch = Config.branch_of config in
  let external_resource = Model.Repo.resolve_path ~branch source repo in
  let path_str =
    match Yocaml.Path.to_string target with
    | "/index.html" -> ""
    | x -> x
  in
  record
    [ ("self_url", Model.Url.(normalize (from_path target)))
    ; "repo_url", Model.Url.normalize external_resource
    ; ("canonical_url", Model.Url.(normalize (https @@ "xvw.lol" ^ path_str)))
    ]
;;

let meta page =
  Model.Common.meta page
  @ Model.Identity.meta_for (Config.owner_of page#configuration)
;;

let normalize page =
  Model.Common.normalize page
  @ [ "config", Config.normalize page#configuration
    ; "build_info", normalize_build_info page
    ; "meta", Model.Meta.normalize_options @@ meta page
    ]
;;
