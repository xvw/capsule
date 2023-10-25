open Yocaml
module Y = Yocaml_yaml
module M = Markdown
module T = Yocaml_jingoo

let process_directories path predicate effect =
  let effects = Yocaml.Effect.collect_child_directories path predicate in
  Yocaml.Effect.sequence effects (fun x () -> effect x) (return ())

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

let client ~target =
  Build.copy_file ~new_name:"capsule.js"
    ~into:(Target.javascript ~target)
    "_build/default/bin/capsule_client/capsule_client.bc.js"

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
  let* () = client ~target in
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

let journal_arrow preapply length i entries =
  let open Build in
  binary_update
  >>> Y.read_file_with_metadata (module Model.Page) "content/journal.md"
  >>> Model.Entries.read_entries (module Y) length i M.string_to_html entries
  >>> preapply
  >>> T.apply_as_template (module Model.Entries) "templates/journal.html"
  >>> T.apply_as_template (module Model.Entries) "templates/page-header.html"
  >>> T.apply_as_template (module Model.Entries) "templates/layout.html"
  >>^ Stdlib.snd

let make_entries ~target entries =
  List.fold_left
    (fun task (date, entry) ->
      let file_target = Target.for_entry ~target entry in
      let next_task =
        let* () =
          Build.create_file file_target
            (journal_arrow Model.Entries.preapply_for_one 1 1 [ (date, entry) ])
        in
        task
      in
      next_task)
    (return ()) entries

let make_journal ~target (length, entries) =
  let _, effect =
    List.fold_left
      (fun (i, task) entries ->
        let file_target = Target.for_entries ~target i in
        let next_task =
          let* () =
            Build.create_file file_target
              (journal_arrow Build.id length i entries)
          in
          make_entries ~target entries
        in

        let t =
          let* () = task in
          next_task
        in

        (i + 1, t))
      (1, return ())
      entries
  in
  effect

let journal ~target ~size =
  let* entries = Model.Entries.get_entries "content/journal" size in
  make_journal ~target entries

let dapps ~target =
  process_directories [ "content/dapps" ] $ File.all $ fun folder ->
  let open Build in
  let folder = Filepath.basename folder in
  let file_target = Target.for_dapp ~target folder in
  let app_file = "app.html" |> into folder |> into "content/dapps" in
  let manifest_file = "manifest.md" |> into folder |> into "content/dapps" in
  create_file file_target
    (binary_update
    >>> (read_file app_file
        &&& Y.read_file_with_metadata (module Model.Dapp) manifest_file)
    >>> Model.Dapp.join_files
    >>> fst
          (Model.Dapp.map_manifest M.string_to_html
          >>> Model.Dapp.map_synopsis M.string_to_html)
    >>> T.apply_as_template (module Model.Dapp) "templates/dapp.html"
    >>> T.apply_as_template (module Model.Dapp) "templates/page-header.html"
    >>> T.apply_as_template (module Model.Dapp) "templates/layout.html"
    >>^ Stdlib.snd)

let pages ~target =
  process_files $ [ "content/pages" ] $ File.is_markdown $ fun page_file ->
  let open Build in
  let file_target = Target.for_page ~target page_file in
  create_file $ file_target $ base_page page_file

let indexes ~target =
  process_files $ [ "content" ] $ File.is_markdown $ fun index_file ->
  let open Build in
  let file_target = Target.for_index ~target index_file in
  create_file $ file_target $ base_page index_file
