type t =
  { url : Url.t
  ; raw_url : Url.t
  ; mime_type : string
  ; width : int option
  ; height : int option
  ; alt : string option
  }

let extract_extension x =
  match String.lowercase_ascii @@ Url.extension x with
  | ".jpg" | ".jpeg" -> Ok "image/jpeg"
  | ".apng" -> Ok "image/apng"
  | ".avif" -> Ok "image/avif"
  | ".bmp" -> Ok "image/bmp"
  | ".gif" -> Ok "image/gif"
  | ".png" -> Ok "image/png"
  | ".svg" -> Ok "image/svg+xml"
  | ".tif" | ".tiff" -> Ok "image/tiff"
  | ".webp" -> Ok "image/webp"
  | given ->
    Yocaml.Data.Validation.fail_with ~given "Unknowm mime/type for image"
;;

let mime_type = Yocaml.Data.Validation.(Url.validate & extract_extension)

let as_plain_url url =
  let open Yocaml.Data.Validation in
  let* url = Url.validate url in
  let+ ext = extract_extension url in
  { url
  ; raw_url = url
  ; mime_type = ext
  ; width = None
  ; height = None
  ; alt = None
  }
;;

let validate =
  let open Yocaml.Data.Validation in
  as_plain_url
  / record (fun fields ->
    let+ url = required fields "url" Url.validate
    and+ mime_type = required fields "url" mime_type
    and+ width = optional fields "width" int
    and+ height = optional fields "height" int
    and+ alt = optional fields "alt" string in
    { url; raw_url = url; mime_type; width; height; alt })
;;

let normalize { url; mime_type; width; height; alt; raw_url } =
  let open Yocaml.Data in
  record
    [ "url", Url.normalize url
    ; "mime_type", string mime_type
    ; "width", option int width
    ; "height", option int height
    ; "alt", option string alt
    ; "raw_url", Url.normalize raw_url
    ]
;;

let meta_for { url; mime_type; width; height; alt; _ } =
  let url = Some (Url.to_string url) in
  [ Meta.from_option "og:image" url
  ; Meta.from_option "og:image:url" url
  ; Meta.from_option "og:image:type" (Some mime_type)
  ; Meta.from_option "og:image:width" (Option.map string_of_int width)
  ; Meta.from_option "og:image:height" (Option.map string_of_int height)
  ; Meta.from_option "og:image:alt" alt
  ]
;;

let resolve url c = { c with url = Url.resolve url c.url }
