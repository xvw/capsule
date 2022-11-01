open Yocaml
open Preface.Predicate

let is_css = with_extension "css"
let is_javascript = with_extension "js"
let is_markdown = with_extension "md" || with_extension "markdown"

let is_image =
  with_extension "png"
  || with_extension "svg"
  || with_extension "jpg"
  || with_extension "jpeg"
  || with_extension "gif"

let is_font =
  with_extension "eot"
  || with_extension "svg"
  || with_extension "ttf"
  || with_extension "woff"
  || with_extension "woff2"

let is_related_to_favicon =
  with_extension "png" || with_extension "ico" || with_extension "manifest"
