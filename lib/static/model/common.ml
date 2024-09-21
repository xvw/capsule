open Yocaml

type t = Types.common

class make title charset description tags display_toc =
  object (_ : #Types.common)
    val toc_value = None
    val description_value = description
    method page_title = title
    method page_charset = charset
    method description = description_value
    method tags = tags
    method display_toc = display_toc
    method toc = toc_value
    method with_toc new_toc = {<toc_value = new_toc>}
    method on_description f = {<description_value = f description_value>}
  end

let validate fields =
  let open Data.Validation in
  let+ title = optional fields "page_title" string
  and+ charset = optional fields "page_charset" string
  and+ description = optional fields "description" string
  and+ tags = optional_or fields ~default:[] "tags" (list_of Slug.validate)
  and+ display_toc = optional_or fields ~default:false "display_toc" bool in
  new make title charset description tags display_toc
;;

let normalize obj =
  let open Model_util in
  let open Yocaml.Data in
  [ "page_title", option string obj#page_title
  ; "page_charset", option string obj#page_charset
  ; "description", option string obj#description
  ; "tags", list_of string obj#tags
  ; "toc", option string obj#toc
  ; "has_toc", bool (obj#display_toc && Option.is_some obj#toc)
  ; "has_page_title", exists_from_opt obj#page_title
  ; "has_page_charset", exists_from_opt obj#page_charset
  ; "has_description", exists_from_opt obj#description
  ]
;;

let inspect x = x
