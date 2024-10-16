module Parse = struct
  class type t = Types.common

  let entity_name = "Page"
  let neutral = Yocaml.Metadata.required entity_name

  let validate =
    let open Yocaml.Data.Validation in
    record Common.validate
  ;;
end

class type t = object
  inherit Parse.t
  inherit Types.with_configuration
  inherit Types.with_target_path
  inherit Types.with_source_path
end

let resolve_cover config cover =
  Option.map (Model.Cover.resolve (Config.main_url_of config)) cover
;;

class make p config source_path target_path =
  object (_ : #t)
    inherit
      Common.t
        ~title:p#page_title
        ~document_kind:p#document_kind
        ~section:p#section
        ~charset:p#page_charset
        ~cover:(resolve_cover config p#cover)
        ~description:p#description
        ~synopsis:p#synopsis
        ~published_at:p#published_at
        ~updated_at:p#updated_at
        ~breadcrumb:p#breadcrumb
        ~indexes:p#indexes
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

let on_page_synopsis f =
  Yocaml.Task.lift (fun metadata -> metadata#on_synopsis f)
;;

let on_index_synopsis f =
  Yocaml.Task.lift (fun metadata ->
    metadata#on_index (fun index ->
      Model.Index.map_synopsis (Option.map f) index))
;;

let on_synopsis f =
  let open Yocaml.Task in
  Static.on_metadata (on_page_synopsis f >>> on_index_synopsis f)
;;

let as_index () =
  let open Yocaml.Task in
  Static.on_metadata
    (lift (fun metadata ->
       metadata#on_document_kind (fun _ -> Model.Types.Index)))
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
  let cover =
    match page#cover with
    | Some x -> Some x
    | None ->
      resolve_cover
        page#configuration
        (Config.default_cover_of page#configuration)
  in
  let meta_cover =
    match cover with
    | None -> []
    | Some x -> Model.Cover.meta_for x
  in
  Common.meta page
  @ Model.Identity.meta_for (Config.owner_of page#configuration)
  @ meta_cover
;;

let normalize page =
  Common.normalize page
  @ [ "config", Config.normalize page#configuration
    ; "build_info", normalize_build_info page
    ; "meta", Model.Meta.normalize_options @@ meta page
    ]
;;
