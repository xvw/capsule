type t =
  { kind : string
  ; date : Yocaml.Datetime.t
  ; city : string
  ; country : string
  ; lang : string
  ; tags : string list
  ; conference : Model.Link.t
  ; slides : Model.Url.t option
  ; video : Model.Url.t option
  ; links : Model.Link.t list
  ; kv : Model.Key_value.String.t
  ; synopsis : string option
  }

let entity_name = "Talk"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ kind = optional_or ~default:"Conférence" fields "kind" string
    and+ date = required fields "date" Yocaml.Datetime.validate
    and+ city = required fields "city" string
    and+ country = required fields "country" string
    and+ lang = optional_or ~default:"fr" fields "lang" string
    and+ conference = required fields "conference" Model.Link.validate
    and+ slides = optional fields "slides" Model.Url.validate
    and+ video = optional fields "video" Model.Url.validate
    and+ links =
      optional_or ~default:[] fields "links" (list_of Model.Link.validate)
    and+ tags =
      optional_or fields ~default:[] "tags" (list_of Yocaml.Slug.validate)
    and+ kv =
      optional_or
        ~default:Model.Key_value.String.empty
        fields
        "kv"
        Model.Key_value.String.validate
    in
    { kind
    ; date
    ; city
    ; country
    ; lang
    ; tags
    ; conference
    ; slides
    ; video
    ; links
    ; kv
    ; synopsis = None
    })
;;

let normalize
      { kind
      ; date
      ; city
      ; country
      ; lang
      ; tags
      ; conference
      ; slides
      ; video
      ; links
      ; kv
      ; synopsis
      }
  =
  let open Model.Model_util in
  let open Yocaml.Data in
  record
    [ "kind", string kind
    ; "date", Yocaml.Datetime.normalize date
    ; "city", string city
    ; "country", string country
    ; "lang", string lang
    ; "tags", list_of string tags
    ; "conference", Model.Link.normalize conference
    ; "slides", option Model.Url.normalize slides
    ; "video", option Model.Url.normalize video
    ; "links", (list_of Model.Link.normalize) links
    ; "kv", Model.Key_value.String.normalize kv
    ; "synopsis", option string synopsis
    ; "has_tags", exists_from_list tags
    ; "has_slides", exists_from_opt slides
    ; "has_video", exists_from_opt video
    ; "has_links", Model.Model_util.exists_from_list links
    ; "has_kv", Model.Key_value.String.has_elements kv
    ; "has_synopsis", exists_from_opt synopsis
    ]
;;

let collapse_content talk synopsis =
  let synopsis = Some synopsis in
  { talk with synopsis }
;;

let date_of { date; _ } = date
let year_of { date = { year; _ }; _ } = (year :> int)
