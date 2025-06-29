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

let process_talks (module R : Intf.RESOLVER) config =
  let module S = Archetype.Speaking.Make (Yocaml_yaml) (R) in
  let target = R.Target.speaking in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      Yocaml.Pipeline.track_file R.Source.talks
      >>> page_arrow
            (module S)
            (module R)
            "speaking.html"
            kind
            config
            R.Source.speaking
            target
      >>> layout_arrow (module S) (module R))
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

let process_projects (module R : Intf.RESOLVER) config projects =
  Yocaml.Action.batch
    ~only:`Directories
    R.Source.Kohai.projects
    (Project.create_project_page
       (module Yocaml_yaml)
       (module R)
       md_to_html
       config
       projects)
;;

let process_now_page (module R : Intf.RESOLVER) =
  Log.create_now_page (module Yocaml_yaml) (module R) md_to_html
;;

let process_activity_page (module R : Intf.RESOLVER) =
  Log.create_activity_page (module Yocaml_yaml) (module R) md_to_html
;;

let process_feed (module R : Intf.RESOLVER) config context =
  let open Yocaml.Eff in
  Feed.create_journal_feed
    (module Yocaml_yaml)
    (module R)
    md_to_html
    config
    context
  >=> Feed.atom_for_entries (module R) config context
  >=> Feed.atom_for_pages (module R) config context
  >=> Feed.atom_for_addresses (module R) config context
  >=> Feed.atom_for_galleries (module R) config context
  >=> Feed.atom_for_journal (module R) config context
  >=> Feed.atom_for_tags (module R) config context
  >=> Feed.atom_for_english_articles (module R) config context
  >=> Feed.atom_for_english_tags (module R) config context
;;

let fetch_config (module R : Intf.RESOLVER) =
  let open Yocaml.Eff.Syntax in
  let* config =
    Yocaml_otoml.Eff.read_file_as_metadata
      (module Archetype.Config)
      ~on:`Source
      R.Source.configuration
  in
  let+ kohai_state =
    Yocaml_rensai.Eff.read_file_as_metadata
      (module Yocaml_kohai.State)
      ~on:`Source
      R.Source.Kohai.state
  in
  Archetype.Config.merge_kohai_state config kohai_state
;;

let fetch_projects (module R : Intf.RESOLVER) =
  let open Yocaml.Eff in
  let+ content = read_file ~on:`Source R.Source.Kohai.Project.list in
  content
  |> Lexing.from_string
  |> Rensai.Lang.from_lexingbuf_to_list
  |> Kohai_model.Described_item.Set.from_ast_list
;;

let english_index (module R : Intf.RESOLVER) config =
  let source = R.Source.En.index in
  let target = Yocaml.Path.(R.Target.En.root / "index.html") in
  Yocaml.Action.Static.write_file_with_metadata
    target
    (let open Yocaml.Task in
     R.track_common_deps
     >>> Yocaml.Pipeline.track_file R.Source.En.articles
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Archetype.Page.Input)
           source
     >>> Archetype.Page.full_configure
           ~config
           ~source
           ~target
           ~on_synopsis:md_to_html
           ~kind:Model.Types.Index
     >>> Yocaml_cmarkit.content_to_html_with_toc
           ~strict:false
           Archetype.Page.table_of_content
     >>> Yocaml.Pipeline.chain_templates
           (module Yocaml_jingoo)
           (module Archetype.Page)
           [ R.Source.template "page.html"
           ; R.Source.template "page-header-en.html"
           ; R.Source.template "layout-en.html"
           ])
;;

let english_page (module R : Intf.RESOLVER) config source =
  let target = R.Target.En.as_article source in
  let kind = Model.Types.Article in
  Yocaml.Action.Static.write_file_with_metadata
    (R.Target.promote target)
    Yocaml.Task.(
      R.track_common_deps
      >>> Yocaml_yaml.Pipeline.read_file_with_metadata
            (module Archetype.Translated_page.Input)
            source
      >>> Archetype.Translated_page.full_configure
            ~config
            ~source
            ~target
            ~kind
            ~on_synopsis:md_to_html
      >>> Yocaml_cmarkit.content_to_html_with_toc
            ~strict:false
            Archetype.Translated_page.table_of_content
      >>> Yocaml.Pipeline.chain_templates
            (module Yocaml_jingoo)
            (module Archetype.Translated_page)
            [ R.Source.template "page.html"
            ; R.Source.template "page-header-en.html"
            ; R.Source.template "layout-en.html"
            ])
;;

let english_pages (module R : Intf.RESOLVER) config =
  Yocaml.Action.batch
    ~only:`Files
    ~where:File.is_markdown
    R.Source.En.articles
    (english_page (module R) config)
;;

let run (module R : Intf.RESOLVER) () =
  let open Yocaml.Eff in
  let* config = fetch_config (module R) in
  let* projects = fetch_projects (module R) in
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
  >>= process_talks (module R) config
  >>= process_projects (module R) config projects
  >>= process_now_page (module R) config
  >>= process_activity_page (module R) config
  >>= process_journal_entries (module R) config
  >>= process_feed (module R) config context
  >>= english_pages (module R) config
  >>= english_index (module R) config
  >>= Yocaml.Action.store_cache ~on:`Source R.Target.cache
;;
