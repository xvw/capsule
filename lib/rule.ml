open Yocaml
module Y = Yocaml_yaml
module M = Markdown
module T = Yocaml_jingoo

let binary_update = Build.watch Sys.argv.(0)

let css ~target =
  process_files
  $ [ "css" ]
  $ File.is_css
  $ Build.copy_file ~into:(Target.css ~target)

let javascript ~target =
  process_files
  $ [ "js"; "hell/_build" ]
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

let favicon ~target =
  process_files
  $ [ "favicon" ]
  $ File.is_related_to_favicon
  $ Build.copy_file ~into:(Target.capsule ~target)

let config ~target =
  process_files
  $ [ "config" ]
  $ File.all
  $ Build.copy_file ~into:(Target.capsule ~target)

let static ~target =
  let* () = css ~target in
  let* () = javascript ~target in
  let* () = fonts ~target in
  let* () = images ~target in
  let* () = favicon ~target in
  let* () = config ~target in
  return ()

let base_page file =
  let open Build in
  binary_update
  >>> Y.read_file_with_metadata (module Model.Page) file
  >>> snd M.string_to_html_with_toc
  >>> fst (Model.Page.map_synopsis M.string_to_html)
  >>> Model.Page.inject_toc
  >>> T.apply_as_template (module Model.Page) "templates/page.html"
  >>> T.apply_as_template (module Model.Page) "templates/indexes.html"
  >>> T.apply_as_template (module Model.Page) "templates/page-header.html"
  >>> T.apply_as_template (module Model.Page) "templates/layout.html"
  >>^ Stdlib.snd

let addresses ~target =
  let open Build in
  process_files $ [ "content/addresses" ] $ File.is_markdown
  $ fun address_file ->
  let file_target = Target.for_address ~target address_file in
  create_file file_target
    (binary_update
    >>> Y.read_file_with_metadata (module Model.Address) address_file
    >>> snd M.string_to_html
    >>> fst (Model.Address.map_synopsis M.string_to_html)
    >>> T.apply_as_template (module Model.Address) "templates/page.html"
    >>> T.apply_as_template (module Model.Address) "templates/address.html"
    >>> T.apply_as_template (module Model.Address) "templates/page-header.html"
    >>> T.apply_as_template (module Model.Address) "templates/layout.html"
    >>^ Stdlib.snd)

let pages ~target =
  process_files $ [ "content/pages" ] $ File.is_markdown $ fun page_file ->
  let open Build in
  let file_target = Target.for_page ~target page_file in
  create_file $ file_target $ base_page page_file

let indexes ~target =
  process_files $ [ "content/" ] $ File.is_markdown $ fun index_file ->
  let open Build in
  let file_target = Target.for_index ~target index_file in
  create_file $ file_target $ base_page index_file
