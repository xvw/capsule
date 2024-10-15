type t =
  { url : Url.t
  ; mime_type : string
  ; width : int option
  ; height : int option
  ; alt : string option
  }

let mime_type =
  Yocaml.Data.Validation.(
    Url.validate
    & fun x ->
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
      Yocaml.Data.Validation.fail_with ~given "Unknowm mime/type for image")
;;

let validate ?root_uri () =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ url = required fields "url" Url.validate
    and+ mime_type = required fields "url" mime_type
    and+ width = optional fields "width" int
    and+ height = optional fields "height" int
    and+ alt = optional fields "alt" string in
    let url =
      match root_uri with
      | None -> url
      | Some root_uri -> Url.resolve root_uri url
    in
    { url; mime_type; width; height; alt })
;;
