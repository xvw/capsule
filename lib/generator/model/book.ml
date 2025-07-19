type kind =
  | Novel
  | Short_stories
  | Poems
  | Essay
  | Comic
  | Technical
  | Zine
  | Manual
  | Misc of string

type t =
  { title : string
  ; volume : int option
  ; subtitle : string option
  ; authors : Identity.t Yocaml.Nel.t
  ; kind : kind
  ; publication_year : int
  ; edition : string option
  ; editor : string
  ; comment : string option
  }

let validate_identity =
  let open Yocaml.Data.Validation in
  (list_of Identity.validate
   & function
   | x :: xs -> Ok Yocaml.Nel.(x :: xs)
   | [] -> fail_with ~given:"[]" "list should not be empty")
  / (Identity.validate $ Yocaml.Nel.singleton)
;;

let validate_kind =
  let open Yocaml.Data.Validation in
  string
  $ String.trim
  $ String.lowercase_ascii
  $ function
  | "novel" | "roman" -> Novel
  | "short_stories" | "short" | "shortstories" -> Short_stories
  | "poems" | "poem" | "poetry" -> Poems
  | "essay" -> Essay
  | "comic" | "bd" | "strip" -> Comic
  | "technical" | "tech" -> Technical
  | "zine" | "magazine" | "newspaper" -> Zine
  | "manual" -> Manual
  | s -> Misc s
;;

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ title = required fields "title" string
    and+ volume = optional fields "volume" int
    and+ subtitle = optional fields "subtitle" string
    and+ authors = required fields "authors" validate_identity
    and+ kind = required fields "kind" validate_kind
    and+ publication_year = required fields "year" int
    and+ edition = optional fields "edition" string
    and+ editor = required fields "editor" string
    and+ comment = optional fields "comment" string in
    { title
    ; volume
    ; subtitle
    ; authors
    ; kind
    ; publication_year
    ; edition
    ; editor
    ; comment
    })
;;

let normalize_kind k =
  let r =
    match k with
    | Essay -> "Essai"
    | Novel -> "Roman"
    | Short_stories -> "Nouvelles"
    | Poems -> "Poésie"
    | Comic -> "BD"
    | Technical -> "Technique"
    | Zine -> "Zine"
    | Manual -> "Manuel"
    | Misc s -> String.capitalize_ascii s
  in
  Yocaml.Data.string r
;;

let display_title title volume subtitle =
  let title = String.capitalize_ascii title in
  match volume, subtitle with
  | Some t, Some s -> Format.asprintf "%s, T%02d - %s" title t s
  | None, Some s -> Format.asprintf "%s - %s" title s
  | Some t, None -> Format.asprintf "%s, T%02d" title t
  | None, None -> title
;;

let normalize
      { title
      ; volume
      ; subtitle
      ; authors
      ; kind
      ; publication_year
      ; edition
      ; editor
      ; comment
      }
  =
  let open Yocaml.Data in
  let authors = Yocaml.Nel.to_list authors in
  record
    [ "title", string title
    ; "display_title", string (display_title title volume subtitle)
    ; "volume", option int volume
    ; "subtitle", option string subtitle
    ; "authors", list_of Identity.normalize authors
    ; ( "authors_repr"
      , string
          (Std.List.textual_enum ~last:"et" Identity.display_name_of authors) )
    ; "kind", normalize_kind kind
    ; "publication_year", int publication_year
    ; "edition", option string edition
    ; "editor", string editor
    ; "comment", option string comment
    ; "has_volume", Model_util.exists_from_opt volume
    ; "has_subtitle", Model_util.exists_from_opt subtitle
    ; "has_edition", Model_util.exists_from_opt edition
    ; "has_comment", Model_util.exists_from_opt comment
    ]
;;
