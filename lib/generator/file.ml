open Yocaml
open Preface.Predicate

let not_emacs_backup f =
  let bname = Filepath.basename f in
  not (String.starts_with ~prefix:".#" bname)

let is_css = not_emacs_backup && with_extension "css"
let is_javascript = not_emacs_backup && with_extension "js"

let is_markdown =
  not_emacs_backup && (with_extension "md" || with_extension "markdown")

let is_html = not_emacs_backup && with_extension "html"

let is_image =
  not_emacs_backup
  && (with_extension "png"
     || with_extension "svg"
     || with_extension "jpg"
     || with_extension "jpeg"
     || with_extension "gif")

let is_font =
  not_emacs_backup
  && (with_extension "eot"
     || with_extension "svg"
     || with_extension "ttf"
     || with_extension "woff"
     || with_extension "woff2")

let is_related_to_favicon =
  not_emacs_backup
  && (with_extension "png" || with_extension "ico" || with_extension "manifest")

let all = not_emacs_backup
