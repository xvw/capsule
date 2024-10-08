type t =
  { title : string
  ; url : Url.t
  }

let equal { title = title_a; url = url_a } { title = title_b; url = url_b } =
  String.equal title_a title_b && Url.equal url_a url_b
;;

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let* url = required fields "url" Url.validate in
    let+ title =
      optional_or
        ~default:(Url.get_url ~with_scheme:false url)
        fields
        "title"
        string
    in
    { url; title })
;;

let normalize { url; title } =
  let open Yocaml.Data in
  record [ "url", Url.normalize url; "title", string title ]
;;
