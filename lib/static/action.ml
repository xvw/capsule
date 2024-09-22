let process_css (module R : Intf.RESOLVER) =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_css
    R.Source.css
    (Yocaml.Action.copy_file ~into:R.Target.css)
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

let process_page (module R : Intf.RESOLVER) config source =
  let target = R.Target.(as_html ~into:pages source) in
  Yocaml.Action.Static.write_file_with_metadata
    target
    Yocaml.Task.(
      R.track_common_deps
      >>> Yocaml_yaml.Pipeline.read_file_with_metadata
            (module Archetype.Page.Parse)
            source
      >>> Archetype.Page.configure config
      >>> Yocaml_cmarkit.content_to_html_with_toc
            Archetype.Page.table_of_contents
      >>> Yocaml_jingoo.Pipeline.as_template
            (module Archetype.Page)
            (R.Source.template "page.html")
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

let fetch_config (module R : Intf.RESOLVER) =
  Yocaml_otoml.Eff.read_file_as_metadata
    (module Model.Config)
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
  >>= process_pages (module R) config
  >>= Yocaml.Action.store_cache ~on:`Source R.Target.cache
;;
