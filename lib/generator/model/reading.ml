type t =
  { book : string
  ; rereading : bool
  ; date : Yocaml.Datetime.t
  ; comment : string option
  }

let entity_name = "Reading"
let neutral = Yocaml.Metadata.required entity_name

let validate_period =
  let open Yocaml.Data.Validation in
  Yocaml.Datetime.validate
  / (string
     & fun given ->
     match String.split_on_char '/' given with
     | [ year; month ] ->
       let dt = year ^ "-" ^ month ^ "-01" in
       Yocaml.Datetime.validate (Yocaml.Data.string dt)
     | _ -> fail_with ~given "Invalid period")
;;

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ book = required fields "book" string
    and+ rereading = optional_or ~default:false fields "rereading" bool
    and+ date = required fields "at" validate_period
    and+ comment = optional fields "comment" string in
    { book; rereading; date; comment })
;;

let normalize { book; rereading; date; comment } =
  let open Yocaml.Data in
  record
    [ "book", string book
    ; "rereading", bool rereading
    ; "date", Yocaml.Datetime.normalize date
    ; "comment", option string comment
    ]
;;

let date_of { date; _ } = date

let period_of r =
  let Yocaml.Datetime.{ year; month; _ } = date_of r in
  year, month
;;
