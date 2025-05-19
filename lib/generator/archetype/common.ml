open Yocaml

class t
  ~document_kind
  ~title
  ~charset
  ~cover
  ~description
  ~synopsis
  ~section
  ~published_at
  ~updated_at
  ~tags
  ~breadcrumb
  ~indexes
  ~display_toc
  ~notes =
  object (self : #Types.common)
    val toc_value = None
    val description_value = description
    val synopsis_value = synopsis
    val indexes_value = indexes
    val document_kind_value = document_kind
    val temporal_notes = notes
    val updated_at_value = updated_at
    val published_at_value = published_at
    method document_kind = document_kind_value
    method page_title = title
    method page_charset = charset
    method cover = cover
    method description = description_value
    method section = section
    method published_at = published_at_value
    method updated_at = updated_at_value
    method synopsis = synopsis_value
    method tags = tags
    method breadcrumb = breadcrumb
    method indexes = indexes_value
    method display_toc = display_toc
    method toc = toc_value
    method notes = temporal_notes
    method with_toc new_toc = {<toc_value = new_toc>}
    method on_description f = {<description_value = f description_value>}
    method on_synopsis f = {<synopsis_value = f synopsis_value>}
    method on_index f = {<indexes_value = Model.Indexes.map f indexes_value>}

    method on_notes f =
      {<temporal_notes = Model.Temporal_note.on_messages f temporal_notes>}

    method on_document_kind f = {<document_kind_value = f document_kind_value>}

    method patch_updated_at nd =
      match updated_at with
      | Some _ -> self
      | None -> {<updated_at_value = nd>}

    method patch_published_at nd =
      match published_at with
      | Some _ -> self
      | None -> {<published_at_value = nd>}
  end

let validate_document_kind =
  let open Yocaml.Data.Validation in
  string
  & fun x ->
  match String.(trim @@ lowercase_ascii x) with
  | "index" -> Ok Model.Types.Index
  | "article" -> Ok Model.Types.Article
  | _ -> fail_with ~given:x "Invalid document kind"
;;

let validate fields =
  let open Data.Validation in
  let+ title = required fields "page_title" string
  and+ document_kind =
    optional_or
      ~default:Model.Types.Article
      fields
      "document_kind"
      validate_document_kind
  and+ charset = optional_or ~default:"utf-8" fields "page_charset" string
  and+ section = optional fields "section" string
  and+ description = optional fields "description" string
  and+ published_at = optional fields "published_at" Yocaml.Datetime.validate
  and+ updated_at = optional fields "updated_at" Yocaml.Datetime.validate
  and+ synopsis = required fields "synopsis" string
  and+ tags = optional_or fields ~default:[] "tags" (list_of Slug.validate)
  and+ cover = optional fields "cover" Model.Cover.validate
  and+ breadcrumb =
    optional_or fields ~default:[] "breadcrumb" (list_of Model.Link.validate)
  and+ indexes =
    optional_or
      ~default:Model.Indexes.empty
      fields
      "indexes"
      Model.Indexes.validate
  and+ display_toc = optional_or fields ~default:false "display_toc" bool
  and+ notes =
    optional_or fields ~default:[] "notes" Model.Temporal_note.validate
  in
  new t
    ~title
    ~document_kind
    ~section
    ~charset:(Some charset)
    ~cover
    ~description
    ~published_at
    ~updated_at
    ~synopsis
    ~tags
    ~breadcrumb
    ~indexes
    ~display_toc
    ~notes
;;

let pseudo_og obj =
  Model.Meta.
    [ from_option "twitter:card" (Some "summary_large_image")
    ; from_option "twitter:title" (Some obj#page_title)
    ; from_option "og:title" (Some obj#page_title)
    ; from_option "twitter:description" obj#description
    ; from_option "og:description" obj#description
    ; from_option "og:site_name" (Some "xvw.lol")
    ]
;;

let article_meta obj =
  match obj#document_kind with
  | Model.Types.Index -> [ Model.Meta.from_option "og:type" (Some "website") ]
  | Model.Types.Article ->
    Model.Meta.
      [ from_option "og:type" (Some "article")
      ; from_option
          "og:article:published_time"
          (Option.map
             (Format.asprintf "%a" Yocaml.Datetime.pp)
             obj#published_at)
      ; from_option
          "og:article:modified_time"
          (Option.map (Format.asprintf "%a" Yocaml.Datetime.pp) obj#updated_at)
      ; from_option "og:article:section" obj#section
      ]
    @ List.map
        (fun tag -> Model.Meta.from_option "og:article:tag" (Some tag))
        obj#tags
;;

let meta obj =
  Model.Meta.
    [ from_list "keywords" obj#tags
    ; from_option "description" obj#description
    ; from_option "generator" (Some "YOCaml")
    ]
  @ pseudo_og obj
  @ article_meta obj
;;

let normalize obj =
  let open Model.Model_util in
  let open Yocaml.Data in
  [ "page_title", string obj#page_title
  ; "page_charset", option string obj#page_charset
  ; "description", option string obj#description
  ; "synopsis", string obj#synopsis
  ; "section", option string obj#section
  ; "published_at", option Yocaml.Datetime.normalize obj#published_at
  ; "updated_at", option Yocaml.Datetime.normalize obj#updated_at
  ; "tags", list_of string obj#tags
  ; "breadcrumb", list_of Model.Link.normalize obj#breadcrumb
  ; "indexes", Model.Indexes.normalize obj#indexes
  ; "cover", option Model.Cover.normalize obj#cover
  ; "notes", Model.Temporal_note.normalize obj#notes
  ; "toc", option string obj#toc
  ; "has_tags", exists_from_list obj#tags
  ; "has_section", exists_from_opt obj#section
  ; "has_toc", bool (obj#display_toc && Option.is_some obj#toc)
  ; "has_page_charset", exists_from_opt obj#page_charset
  ; "has_description", exists_from_opt obj#description
  ; "has_cover", exists_from_opt obj#cover
  ; "has_breadcrumb", exists_from_list obj#breadcrumb
  ; "has_indexes", exists_from_list obj#indexes
  ; "has_notes", exists_from_list obj#notes
  ; "has_published_date", exists_from_opt obj#published_at
  ; "has_updated_date", exists_from_opt obj#updated_at
  ; ( "has_publication_date"
    , bool (Option.is_some obj#published_at || Option.is_some obj#updated_at) )
  ]
;;
