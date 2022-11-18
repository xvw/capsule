open Util
open Yocaml

module KVMap = struct
  type t = { key : string; value : string }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ key = Meta.(required_assoc string) "key" assoc
      and+ value = Meta.(required_assoc string) "value" assoc in
      { key; value }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { key; value } =
    let open Lang in
    [ ("key", string key); ("value", string value) ]

  let inject_list (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      =
    List.map (fun l -> Lang.object_ $ inject (module Lang) l)
end

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

  let compare { name = name_a; _ } { name = name_b; _ } =
    String.compare name_a name_b
end

module Index = struct
  type t = { name : string; synopsis : string; links : Link.t list }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ name = Meta.(required_assoc string) "name" assoc
      and+ synopsis = Meta.(required_assoc string) "synopsis" assoc
      and+ sort = Meta.(optional_assoc_or ~default:false boolean) "sort" assoc
      and+ links =
        Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
          "links" assoc
      in

      {
        name
      ; synopsis
      ; links = (if sort then List.sort Link.compare links else links)
      }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { name; synopsis; links } =
    let open Lang in
    [
      ("name", string name)
    ; ("synopsis", string synopsis)
    ; ("links", list $ Link.inject_list (module Lang) links)
    ; ("anchor", string $ poor_slug name)
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
    ; creation_date : Date.t option
    ; update_date : Date.t option
    ; toc : string option
    ; display_toc : bool
    ; indexes : Index.t list
  }

  let map_synopsis arr =
    let open Build in
    (fun meta -> (meta.synopsis, meta)) ^>> fst arr >>^ fun (synopsis, m) ->
    { m with synopsis }

  let inject_toc =
    Build.arrow (fun (meta, (toc, content)) ->
        ({ meta with toc = Some toc }, content))

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let date = Metadata.Date.from (module Meta) in
    let open Validate.Applicative in
    let+ title = Meta.(required_assoc string) "title" assoc
    and+ description = Meta.(required_assoc string) "description" assoc
    and+ synopsis = Meta.(required_assoc string) "synopsis" assoc
    and+ indexed =
      Meta.(optional_assoc_or ~default:true boolean) "indexed" assoc
    and+ display_toc =
      Meta.(optional_assoc_or ~default:true boolean) "toc" assoc
    and+ creation_date = Meta.(optional_assoc date) "creation_date" assoc
    and+ update_date = Meta.(optional_assoc date) "update_date" assoc
    and+ tags =
      Meta.(optional_assoc_or ~default:[] (list_of string)) "tags" assoc
    and+ breadcrumb =
      Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
        "breadcrumb" assoc
    and+ indexes =
      Meta.(optional_assoc_or ~default:[] (list_of $ Index.from (module Meta)))
        "indexes" assoc
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
    ; indexes
    }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

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
      ; indexes
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
    ; ("creation_date", Option.fold ~none:null ~some:date creation_date)
    ; ("update_date", Option.fold ~none:null ~some:date update_date)
    ; ("breadcrumb", list $ Link.inject_list (module Lang) breadcrumb)
    ; ("indexes", list $ Index.inject_list (module Lang) indexes)
    ; ("has_indexes", boolean $ is_not_empty_list indexes)
    ; ("has_breadcrumb", boolean $ is_not_empty_list breadcrumb)
    ; ("has_tags", boolean $ is_not_empty_list tags)
    ; ("has_creation_date", boolean $ Option.is_some creation_date)
    ; ("has_update_date", boolean $ Option.is_some update_date)
    ; ("has_toc", boolean has_toc)
    ; ("display_toc", boolean (display_toc && has_toc))
    ; ("html_title", string title)
    ; ("html_meta_description", string description)
    ; ("html_meta_keywords", string $ String.concat ", " ("capsule" :: tags))
    ; ("toc", Option.fold ~none:null ~some:string toc)
    ]
end

module type ATTACH_PAGE = sig
  type t

  val get_page : t -> Page.t
  val set_page : Page.t -> t -> t
end

module type WITH_PAGE = sig
  type t

  val map_synopsis : (string, string) Build.t -> (t, t) Build.t
end

module Attach_page (P : ATTACH_PAGE) = struct
  let map_synopsis arr =
    let open Build in
    (fun meta -> (P.get_page meta, meta)) ^>> fst (Page.map_synopsis arr)
    >>^ fun (new_page, meta) -> P.set_page new_page meta
end

module Address = struct
  type t = {
      page : Page.t
    ; country : string
    ; city : string
    ; zipcode : string
    ; address : string
    ; additional_fields : KVMap.t list
    ; nominatim_address : string
  }

  let nominatim_address country city zipcode address =
    let address = poor_slug ~space:"+" address
    and country = poor_slug ~space:"+" country
    and city = poor_slug ~space:"+" city in
    Format.asprintf "street=%s&city=%s&country=%s&postalcode=%s" address city
      country zipcode

  include Attach_page (struct
    type nonrec t = t

    let get_page { page; _ } = page
    let set_page page address = { address with page }
  end)

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let open Validate.Applicative in
    let+ page = Page.validate (module Meta) assoc
    and+ country = Meta.(required_assoc string) "country" assoc
    and+ city = Meta.(required_assoc string) "city" assoc
    and+ zipcode = Meta.(required_assoc string) "zipcode" assoc
    and+ address = Meta.(required_assoc string) "address" assoc
    and+ additional_fields =
      Meta.(optional_assoc_or ~default:[] (list_of $ KVMap.from (module Meta)))
        "additional_fields" assoc
    in
    {
      page
    ; country
    ; city
    ; zipcode
    ; address
    ; additional_fields
    ; nominatim_address = nominatim_address country city zipcode address
    }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Address" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      {
        page
      ; country
      ; city
      ; zipcode
      ; address
      ; additional_fields
      ; nominatim_address
      } =
    Page.inject (module Lang) page
    @ Lang.
        [
          ("country", string country)
        ; ("city", string city)
        ; ("zipcode", string zipcode)
        ; ("address", string address)
        ; ( "additional_fields"
          , list $ KVMap.inject_list (module Lang) additional_fields )
        ; ("nominatim_address", string nominatim_address)
        ]
end
