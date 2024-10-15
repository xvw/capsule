open Yocaml

class t
  ~document_kind
  ~title
  ~charset
  ~description
  ~synopsis
  ~section
  ~published_at
  ~updated_at
  ~tags
  ~breadcrumb
  ~display_toc =
  object (_ : #Types.common)
    val toc_value = None
    val description_value = description
    val synopsis_value = synopsis
    method document_kind = document_kind
    method page_title = title
    method page_charset = charset
    method description = description_value
    method section = section
    method published_at = published_at
    method updated_at = updated_at
    method synopsis = synopsis_value
    method tags = tags
    method breadcrumb = breadcrumb
    method display_toc = display_toc
    method toc = toc_value
    method with_toc new_toc = {<toc_value = new_toc>}
    method on_description f = {<description_value = f description_value>}
    method on_synopsis f = {<synopsis_value = f synopsis_value>}
  end

let validate_document_kind =
  let open Yocaml.Data.Validation in
  string
  & fun x ->
  match String.(trim @@ lowercase_ascii x) with
  | "page" -> Ok Types.Page
  | "article" -> Ok Types.Article
  | _ -> fail_with ~given:x "Invalid document kind"
;;

let validate fields =
  let open Data.Validation in
  let+ title = optional fields "page_title" string
  and+ document_kind =
    optional_or
      ~default:Types.Article
      fields
      "document_kind"
      validate_document_kind
  and+ charset = optional_or ~default:"utf-8" fields "page_charset" string
  and+ section = optional fields "section" string
  and+ description = optional fields "description" string
  and+ published_at =
    optional fields "published_at" Yocaml.Archetype.Datetime.validate
  and+ updated_at =
    optional fields "updated_at" Yocaml.Archetype.Datetime.validate
  and+ synopsis = required fields "synopsis" string
  and+ tags = optional_or fields ~default:[] "tags" (list_of Slug.validate)
  and+ breadcrumb =
    optional_or fields ~default:[] "breadcrumb" (list_of Link.validate)
  and+ display_toc = optional_or fields ~default:false "display_toc" bool in
  new t
    ~title
    ~document_kind
    ~section
    ~charset:(Some charset)
    ~description
    ~published_at
    ~updated_at
    ~synopsis
    ~tags
    ~breadcrumb
    ~display_toc
;;

let pseudo_og obj =
  [ Meta.from_option "twitter:card" (Some "summary_large_image")
  ; Meta.from_option "twitter:title" obj#page_title
  ; Meta.from_option "og:title" obj#page_title
  ; Meta.from_option "twitter:description" obj#description
  ; Meta.from_option "og:description" obj#description
  ; Meta.from_option "og:site_name" (Some "xvw.lol")
  ]
;;

let article_meta obj =
  match obj#document_kind with
  | Types.Page -> [ Meta.from_option "og:type" (Some "website") ]
  | Types.Article ->
    [ Meta.from_option "og:type" (Some "article")
    ; Meta.from_option
        "og:article:published_time"
        (Option.map
           (Format.asprintf "%a" Yocaml.Archetype.Datetime.pp)
           obj#published_at)
    ; Meta.from_option
        "og:article:modified_time"
        (Option.map
           (Format.asprintf "%a" Yocaml.Archetype.Datetime.pp)
           obj#updated_at)
    ; Meta.from_option "og:article:section" obj#section
    ]
    @ List.map
        (fun tag -> Meta.from_option "og:article:tag" (Some tag))
        obj#tags
;;

let meta obj =
  [ Meta.from_list "keywords" obj#tags
  ; Meta.from_option "description" obj#description
  ; Meta.from_option "generator" (Some "YOCaml")
  ]
  @ pseudo_og obj
  @ article_meta obj
;;

let normalize obj =
  let open Model_util in
  let open Yocaml.Data in
  [ "page_title", option string obj#page_title
  ; "page_charset", option string obj#page_charset
  ; "description", option string obj#description
  ; "synopsis", string obj#synopsis
  ; "section", option string obj#section
  ; "published_at", option Yocaml.Archetype.Datetime.normalize obj#published_at
  ; "updated_at", option Yocaml.Archetype.Datetime.normalize obj#updated_at
  ; "tags", list_of string obj#tags
  ; "breadcrumb", list_of Link.normalize obj#breadcrumb
  ; "toc", option string obj#toc
  ; "has_section", exists_from_opt obj#section
  ; "has_toc", bool (obj#display_toc && Option.is_some obj#toc)
  ; "has_page_title", exists_from_opt obj#page_title
  ; "has_page_charset", exists_from_opt obj#page_charset
  ; "has_description", exists_from_opt obj#description
  ; "has_breadcrumb", exists_from_list obj#breadcrumb
  ; "has_published_date", exists_from_opt obj#published_at
  ; "has_updated_date", exists_from_opt obj#updated_at
  ; ( "has_publication_date"
    , bool (Option.is_some obj#published_at || Option.is_some obj#updated_at) )
  ]
;;
