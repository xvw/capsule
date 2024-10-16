open Yocaml

let one_of exts path = List.exists (fun ext -> Path.has_extension ext path) exts
let is_markdown = one_of [ "md"; "markdown" ]
let is_css = one_of [ "css" ]
let is_image = one_of [ "png"; "svg"; "jpg"; "jpeg"; "gif" ]
let is_font = one_of [ "eot"; "svg"; "ttf"; "woff"; "woff2" ]
let is_related_to_favicon = one_of [ "png"; "ico"; "webmanifest" ]
