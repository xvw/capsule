open Util
open Yocaml

module Link = struct
  type t = {
      name : string
    ; href : string
    ; title : string option
    ; description : string option
  }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ name = Meta.(required_assoc string) "name" assoc
      and+ href = Meta.(required_assoc string) "href" assoc
      and+ title = Meta.(optional_assoc string) "title" assoc
      and+ description = Meta.(optional_assoc string) "description" assoc in
      { name; href; title; description }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { name; href; title; description } =
    let open Lang in
    [
      ("name", string name)
    ; ("href", string href)
    ; ("title", Option.fold ~none:null ~some:string title)
    ; ("description", Option.fold ~none:null ~some:string description)
    ; ("has_title", boolean $ Option.is_some title)
    ; ("has_description", boolean $ Option.is_some description)
    ]

  let inject_list (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      =
    List.map (fun l -> Lang.object_ $ inject (module Lang) l)
end

module Page = struct
  type t = {
      title : string
    ; description : string
    ; breadcrumb : Link.t list
    ; synopsis : string
    ; indexed : bool
    ; tags : string list
    ; creation_date : Date.t
    ; update_date : Date.t option
    ; toc : string option
    ; display_toc : bool
  }

  let map_synopsis arr =
    let open Build in
    (fun meta -> (meta.synopsis, meta)) ^>> fst arr >>^ fun (synopsis, m) ->
    { m with synopsis }

  let inject_toc =
    Build.arrow (fun (meta, (toc, content)) ->
        ({ meta with toc = Some toc }, content))

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let date = Metadata.Date.from (module Meta) in
    let validation assoc =
      let open Validate.Applicative in
      let+ title = Meta.(required_assoc string) "title" assoc
      and+ description = Meta.(required_assoc string) "description" assoc
      and+ synopsis = Meta.(required_assoc string) "synopsis" assoc
      and+ indexed =
        Meta.(optional_assoc_or ~default:true boolean) "indexed" assoc
      and+ display_toc =
        Meta.(optional_assoc_or ~default:true boolean) "toc" assoc
      and+ creation_date = Meta.(required_assoc date) "creation_date" assoc
      and+ update_date = Meta.(optional_assoc date) "update_date" assoc
      and+ tags =
        Meta.(optional_assoc_or ~default:[] (list_of string)) "tags" assoc
      and+ breadcrumb =
        Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
          "breadcrumb" assoc
      in
      {
        title
      ; description
      ; breadcrumb
      ; synopsis
      ; indexed
      ; creation_date
      ; update_date
      ; tags = List.map String.trim tags
      ; toc = None
      ; display_toc
      }
    in
    Meta.object_and validation metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Page" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      {
        title
      ; description
      ; breadcrumb
      ; synopsis
      ; indexed
      ; creation_date
      ; update_date
      ; tags
      ; toc
      ; display_toc
      } =
    let open Lang in
    let date x = object_ $ Metadata.Date.inject (module Lang) x in
    let has_toc = Option.is_some toc in
    [
      ("title", string title)
    ; ("description", string description)
    ; ("synopsis", string synopsis)
    ; ("indexed", boolean indexed)
    ; ("tags", list $ List.map string tags)
    ; ("creation_date", date creation_date)
    ; ("update_date", Option.fold ~none:null ~some:date update_date)
    ; ("breadcrumb", list $ Link.inject_list (module Lang) breadcrumb)
    ; ("has_breadcrumb", boolean $ is_not_empty_list breadcrumb)
    ; ("has_tags", boolean $ is_not_empty_list tags)
    ; ("has_update_date", boolean $ Option.is_some update_date)
    ; ("has_toc", boolean has_toc)
    ; ("display_toc", boolean (display_toc && has_toc))
    ; ("html_title", string title)
    ; ("html_meta_description", string description)
    ; ("html_meta_keywords", string $ String.concat ", " ("capsule" :: tags))
    ; ("toc", Option.fold ~none:null ~some:string toc)
    ]
end
