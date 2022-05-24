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
