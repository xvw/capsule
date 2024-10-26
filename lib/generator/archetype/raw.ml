module Input = struct
  class type t = Types.common

  let to_entry ~file ~url input =
    Model.Entry.make
      ~title:input#page_title
      ~content_url:url
      ~tags:input#tags
      ~summary:input#synopsis
      ~file
      ~datetime:
        Std.Option.(
          input#updated_at <|> input#published_at || Yocaml.Datetime.dummy)
      ()
  ;;

  let validate = Yocaml.Data.Validation.record Common.validate
end

module Output = struct
  class type t = object
    inherit Input.t
    inherit Types.with_configuration
    inherit Types.with_target_path
    inherit Types.with_source_path
  end

  class output input config source_path target_path =
    object (_ : #t)
      inherit
        Common.t
          ~title:input#page_title
          ~document_kind:input#document_kind
          ~section:input#section
          ~charset:input#page_charset
          ~cover:(Config.resolve_cover config input#cover)
          ~description:input#description
          ~synopsis:input#synopsis
          ~published_at:input#published_at
          ~updated_at:input#updated_at
          ~breadcrumb:input#breadcrumb
          ~indexes:input#indexes
          ~tags:input#tags
          ~display_toc:input#display_toc
          ~notes:input#notes

      method configuration = config
      method source_path = source_path
      method target_path = target_path
    end

  let configure ~config ~source ~target input =
    new output input config source target
  ;;

  let on_synopsis f output =
    ((output#on_synopsis f)#on_notes f)#on_index
      (Model.Index.map_synopsis (Option.map f))
  ;;

  let define_document_kind kind output = output#on_document_kind (fun _ -> kind)

  let full_configure ~config ~source ~target ~kind ~on_synopsis:f input =
    input
    |> configure ~config ~source ~target
    |> define_document_kind kind
    |> on_synopsis f
  ;;

  let table_of_content output = output#with_toc

  let normalize_build_info output =
    let open Yocaml.Data in
    let target =
      Yocaml.Path.relocate ~into:Yocaml.Path.root output#target_path
    in
    let config = output#configuration in
    let source = output#source_path in
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

  let meta output =
    let cover =
      match output#cover with
      | Some x -> Some x
      | None ->
        Config.resolve_cover
          output#configuration
          (Config.default_cover_of output#configuration)
    in
    let meta_cover =
      match cover with
      | None -> []
      | Some x -> Model.Cover.meta_for x
    in
    Common.meta output
    @ Model.Identity.meta_for (Config.owner_of output#configuration)
    @ meta_cover
  ;;

  let normalize output =
    Common.normalize output
    @ [ "config", Config.normalize output#configuration
      ; "build_info", normalize_build_info output
      ; "meta", Model.Meta.normalize_options @@ meta output
      ]
  ;;
end
