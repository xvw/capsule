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
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_image
    R.Source.images
    (Yocaml.Action.copy_file ~into:R.Target.images)
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

let page_arrow (module R : Intf.RESOLVER) ~kind config source target =
  let open Yocaml.Task in
  R.track_common_deps
  >>> Yocaml_yaml.Pipeline.read_file_with_metadata
        (module Archetype.Page.Parse)
        source
  >>> Archetype.Page.configure config ~source ~target
  >>> Archetype.Page.on_synopsis md_to_html
  >>> Archetype.Page.define_document_kind kind
  >>> Yocaml_cmarkit.content_to_html_with_toc Archetype.Page.table_of_contents
  >>> Yocaml_jingoo.Pipeline.as_template
        (module Archetype.Page)
        (R.Source.template "page.html")
;;

let process_page (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_page source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow (module R) ~kind config source target
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Page)
            (R.Source.template "layout.html"))
;;

let process_index (module R : Intf.RESOLVER) config source =
  let target = R.Target.as_index source in
  let kind = Model.Types.Index in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      page_arrow ~kind (module R) config source target
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Page)
            (R.Source.template "index.html")
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Page)
            (R.Source.template "layout.html"))
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

let fetch_config (module R : Intf.RESOLVER) =
  Yocaml_otoml.Eff.read_file_as_metadata
    (module Archetype.Config)
    ~on:`Source
    R.Source.configuration
;;

let run (module R : Intf.RESOLVER) () =
  let open Yocaml.Eff in
  let* config = fetch_config (module R) in
  Yocaml.Action.restore_cache ~on:`Source R.Target.cache
  >>= process_fonts (module R)
  >>= process_css (module R)
  >>= process_images (module R)
  >>= process_js (module R)
  >>= process_misc_files (module R)
  >>= process_pages (module R) config
  >>= process_indexes (module R) config
  >>= Yocaml.Action.store_cache ~on:`Source R.Target.cache
;;
