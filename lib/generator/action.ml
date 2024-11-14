let md_to_html ?strict ?(safe = true) content =
  content |> Cmarkit.Doc.of_string ?strict |> Cmarkit_html.of_doc ~safe
;;

let process_fonts (module R : Intf.RESOLVER) =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_font
    R.Source.fonts
    (Yocaml.Action.copy_file ~into:R.Target.fonts)
;;

let process_images (module R : Intf.RESOLVER) =
  let copy_image = Yocaml.Action.copy_file ~into:R.Target.images in
  let batch source =
    Yocaml.Action.batch ~only:`Files ~where:File.is_image source copy_image
  in
  let open Yocaml.Eff in
  batch R.Source.images >=> batch R.Source.content_images
;;

let process_maps (module R : Intf.RESOLVER) =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_image
    R.Source.maps
    (Yocaml.Action.copy_file ~into:R.Target.maps)
;;

let process_d2_diagrams (module R : Intf.RESOLVER) =
  Yocaml.Action.batch ~only:`Files ~where:File.is_d2 R.Source.d2 (fun source ->
    let target = R.Target.as_diagram source in
    let command target =
      Yocaml.Cmd.(
        make
          "d2"
          [ param ~prefix:"-" "t" (int 301)
          ; param ~suffix:"=" "layout" (string "elk")
          ; arg (w source)
          ; arg target
          ])
    in
    Yocaml.Action.exec_cmd command target)
;;

let process_js (module R : Intf.RESOLVER) =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_javascript
    R.Source.js
    (Yocaml.Action.copy_file ~into:R.Target.js)
;;

let process_css (module R : Intf.RESOLVER) =
  Yocaml.Action.Static.write_file
    R.Target.css
    (Yocaml.Pipeline.pipe_files
       ~separator:"\n"
       Yocaml.Path.
         [ R.Source.css / "fonts.css"
         ; R.Source.css / "reset.css"
         ; R.Source.css / "hl.css"
         ; R.Source.css / "capsule.css"
         ])
;;

let process_misc_files (module R : Intf.RESOLVER) =
  let open Yocaml.Eff in
  Yocaml.Action.copy_file ~into:R.Target.root R.Source.cname
  >=> Yocaml.Action.batch
        ~only:`Files
        ~where:File.is_related_to_favicon
        R.Source.favicon
        (Yocaml.Action.copy_file ~into:R.Target.root)
;;

let layout_arrow
  (type a)
  (module A : Archetype.Types.ARCHETYPE with type t = a)
  (module R : Intf.RESOLVER)
  =
  let open Yocaml.Task in
  Yocaml_jingoo.Pipeline.as_template
    (module A)
    (R.Source.template "page-header.html")
  >>> Yocaml_jingoo.Pipeline.as_template
        (module A)
        (R.Source.template "layout.html")
;;

let page_arrow
  (type a b)
  (module A : Archetype.Types.ARCHETYPE with type t = a and type Input.t = b)
  (module R : Intf.RESOLVER)
  template
  kind
  config
  source
  target
  =
  let open Yocaml.Task in
  R.track_common_deps
  >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module A.Input) source
  >>> A.full_configure ~config ~source ~target ~kind ~on_synopsis:md_to_html
  >>> Yocaml_cmarkit.content_to_html_with_toc ~strict:false A.table_of_content
  >>> Yocaml_jingoo.Pipeline.as_template (module A) (R.Source.template template)
;;

let process_page (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_page source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow
        (module Archetype.Page)
        (module R)
        "page.html"
        kind
        config
        source
        target
      >>> layout_arrow (module Archetype.Page) (module R))
;;

let process_address (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_address source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow
        (module Archetype.Address)
        (module R)
        "page.html"
        kind
        config
        source
        target
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Address)
            (R.Source.template "address.html")
      >>> layout_arrow (module Archetype.Address) (module R))
;;

let process_gallery (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_gallery source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow
        (module Archetype.Gallery)
        (module R)
        "gallery.html"
        kind
        config
        source
        target
      >>> layout_arrow (module Archetype.Gallery) (module R))
;;

let process_journal_entry (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_journal_entry source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow
        (module Archetype.Journal_entry)
        (module R)
        "journal-entry.html"
        kind
        config
        source
        target
      >>> layout_arrow (module Archetype.Journal_entry) (module R))
;;

let process_index (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_index source in
  let kind = Model.Types.Index in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow
        (module Archetype.Page)
        (module R)
        "page.html"
        kind
        config
        source
        target
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Page)
            (R.Source.template "index.html")
      >>> layout_arrow (module Archetype.Page) (module R))
;;

let process_pages (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.pages
    (process_page (module R) config)
;;

let process_indexes (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.indexes
    (process_index (module R) config)
;;

let process_addresses (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.addresses
    (process_address (module R) config)
;;

let process_galleries (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.galleries
    (process_gallery (module R) config)
;;

let process_journal_entries (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.journal_entries
    (process_journal_entry (module R) config)
;;

let process_feed (module R : Intf.RESOLVER) config context =
  let open Yocaml.Eff in
  Feed.atom_for_entries (module R) config context
  >=> Feed.atom_for_pages (module R) config context
  >=> Feed.atom_for_addresses (module R) config context
  >=> Feed.atom_for_galleries (module R) config context
  >=> Feed.atom_for_journal (module R) config context
  >=> Feed.atom_for_tags (module R) config context
;;

let fetch_config (module R : Intf.RESOLVER) =
  Yocaml_otoml.Eff.read_file_as_metadata
    (module Archetype.Config)
    ~on:`Source
    R.Source.configuration
;;

let run (module R : Intf.RESOLVER) () =
  let open Yocaml.Eff in
  let* config = fetch_config (module R) in
  let* context = Feed.make (module Yocaml_yaml) (module R) in
  Yocaml.Action.restore_cache ~on:`Source R.Target.cache
  >>= process_fonts (module R)
  >>= process_css (module R)
  >>= process_images (module R)
  >>= process_d2_diagrams (module R)
  >>= process_maps (module R)
  >>= process_js (module R)
  >>= process_misc_files (module R)
  >>= process_pages (module R) config
  >>= process_indexes (module R) config
  >>= process_addresses (module R) config
  >>= process_galleries (module R) config
  >>= process_journal_entries (module R) config
  >>= process_feed (module R) config context
  >>= Yocaml.Action.store_cache ~on:`Source R.Target.cache
;;
