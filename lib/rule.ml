open Yocaml
module Y = Yocaml_yaml
module M = Yocaml_markdown
module T = Yocaml_jingoo

let binary_update = Build.watch Sys.argv.(0)

let css ~target =
  process_files
  $ [ "css" ]
  $ File.is_css
  $ Build.copy_file ~into:(Target.css ~target)

let javascript ~target =
  process_files
  $ [ "js" ]
  $ File.is_javascript
  $ Build.copy_file ~into:(Target.javascript ~target)

let fonts ~target =
  process_files
  $ [ "fonts" ]
  $ File.is_font
  $ Build.copy_file ~into:(Target.fonts ~target)

let images ~target =
  process_files
  $ [ "images" ]
  $ File.is_image
  $ Build.copy_file ~into:(Target.images ~target)

let static ~target =
  let* () = css ~target in
  let* () = javascript ~target in
  let* () = fonts ~target in
  let* () = images ~target in
  return ()

let pages ~target =
  process_files [ "content/pages" ] File.is_markdown (fun page_file ->
      let open Build in
      let file_target = Target.for_page ~target page_file in
      create_file file_target
        (binary_update
        >>> Y.read_file_with_metadata (module Model.Page) page_file
        >>> M.content_to_html ()
        >>> fst (Model.Page.map_synopsis M.to_html)
        >>> T.apply_as_template (module Model.Page) "templates/page.html"
        >>> T.apply_as_template (module Model.Page) "templates/layout.html"
        >>^ Stdlib.snd))
