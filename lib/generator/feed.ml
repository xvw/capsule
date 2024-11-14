module M = Map.Make (String)

type t =
  { pages : Model.Entry.t list
  ; addresses : Model.Entry.t list
  ; entries : Model.Entry.t list
  ; galleries : Model.Entry.t list
  ; journal_entries : Model.Entry.t list
  ; journal_meta :
      (Archetype.Journal_entry.Input.t * string * Yocaml.Path.t) list
  ; by_tags : Model.Entry.t list M.t
  }
[@@ocaml.warning "-69"]

let from_source
  (type a)
  (module P : Yocaml.Required.DATA_PROVIDER)
  (module D : Yocaml.Required.DATA_READABLE with type t = a)
  ?(on = `Source)
  ~where
  ~to_entry
  ~compute_link
  path
  =
  let open Yocaml.Eff in
  let* files = read_directory ~on ~only:`Files ~where path in
  let+ elements =
    List.traverse
      (fun file ->
        let url = compute_link file in
        let+ metadata, _content =
          read_file_with_metadata (module P) (module D) ~on file
        in
        to_entry ~file ~url metadata)
      files
  in
  elements
;;

let journal_entries
  (module P : Yocaml.Required.DATA_PROVIDER)
  (module R : Intf.RESOLVER)
  =
  let open Yocaml.Eff in
  let* files =
    read_directory
      ~on:`Source
      ~only:`Files
      ~where:File.is_markdown
      R.Source.journal_entries
  in
  let+ elements =
    List.traverse
      (fun file ->
        let url = R.Target.as_journal_entry file in
        let+ metadata, content =
          read_file_with_metadata
            (module P)
            (module Archetype.Journal_entry.Input)
            ~on:`Source
            file
        in
        let metadata =
          Archetype.Journal_entry.replace_datetime ~file metadata
        in
        ( (metadata, content, file)
        , Archetype.Journal_entry.Input.to_entry ~file ~url metadata ))
      files
  in
  elements |> Stdlib.List.split
;;

let compute_map_from_tags source m =
  List.fold_left
    (fun m entry ->
      List.fold_left
        (fun m tag ->
          M.update
            tag
            (function
              | None -> Some [ entry ]
              | Some xs -> Some (entry :: xs))
            m)
        m
        (Model.Entry.tags_of entry))
    m
    source
;;

let sort_entries = List.sort Model.Entry.rev_compare
let sort_map m = M.map sort_entries m

let sort_journal_meta (a, _, _) (b, _, _) =
  Archetype.Journal_entry.rev_compare_input a b
;;

let build_context pages addresses galleries (jmeta, jentries) =
  let entries = pages @ addresses @ galleries @ jentries in
  { pages = sort_entries pages
  ; journal_entries = sort_entries jentries
  ; journal_meta = List.sort sort_journal_meta jmeta
  ; galleries = sort_entries galleries
  ; addresses = sort_entries addresses
  ; entries = sort_entries entries
  ; by_tags = M.empty |> compute_map_from_tags entries |> sort_map
  }
;;

let make (module P : Yocaml.Required.DATA_PROVIDER) (module R : Intf.RESOLVER) =
  let open Yocaml.Eff in
  let* pages =
    from_source
      (module P)
      (module Archetype.Page.Input)
      ~on:`Source
      ~where:File.is_markdown
      ~to_entry:Archetype.Page.Input.to_entry
      ~compute_link:R.Target.as_page
      R.Source.pages
  in
  let* addresses =
    from_source
      (module P)
      (module Archetype.Address.Input)
      ~on:`Source
      ~where:File.is_markdown
      ~to_entry:Archetype.Address.Input.to_entry
      ~compute_link:R.Target.as_address
      R.Source.addresses
  in
  let* galleries =
    from_source
      (module P)
      (module Archetype.Gallery.Input)
      ~on:`Source
      ~where:File.is_markdown
      ~to_entry:Archetype.Gallery.Input.to_entry
      ~compute_link:R.Target.as_gallery
      R.Source.galleries
  in
  let* journal_entries = journal_entries (module P) (module R) in
  return @@ build_context pages addresses galleries journal_entries
;;

let create_journal_feed config { journal_meta; _ } cache =
  let by_page = Archetype.Config.journal_entries_per_page config in
  let entries = Std.List.split_by_size by_page journal_meta in
  let len = List.length entries in
  let open Yocaml.Eff in
  let+ cache, _ =
    Yocaml.Action.fold_list
      ~state:0
      entries
      (fun entries state cache ->
         
      )
      cache
  in
  cache
;;

let configure_feed config id title =
  let open Yocaml_syndication in
  let base_url = Archetype.Config.main_url_of config in
  let feed_id = Model.Url.to_string base_url ^ "/" ^ id ^ ".xml"
  and title = Atom.text @@ "xvw." ^ id
  and subtitle = Atom.text title
  and authors =
    Yocaml.Nel.singleton
      (config |> Archetype.Config.owner_of |> Model.Identity.to_person)
  and updated = Atom.updated_from_entries () in
  Atom.from
    ~subtitle
    ~title
    ~authors
    ~updated
    ~id:feed_id
    (Model.Entry.to_atom ~base_url)
;;

let atom_for_entries (module R : Intf.RESOLVER) config { entries; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.general
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_files
       [ R.Source.pages
       ; R.Source.addresses
       ; R.Source.galleries
       ; R.Source.journal_entries
       ]
     >>> R.track_common_deps
     >>> const entries
     >>> configure_feed config "feed" "Fil complet d'actualité")
;;

let atom_for_pages (module R : Intf.RESOLVER) config { pages; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.pages
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_file R.Source.pages
     >>> R.track_common_deps
     >>> const pages
     >>> configure_feed config "pages" "Pages et articles")
;;

let atom_for_addresses (module R : Intf.RESOLVER) config { addresses; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.addresses
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_file R.Source.addresses
     >>> R.track_common_deps
     >>> const addresses
     >>> configure_feed config "adresses" "Critiques d'adresses")
;;

let atom_for_galleries (module R : Intf.RESOLVER) config { galleries; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.galleries
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_file R.Source.galleries
     >>> R.track_common_deps
     >>> const galleries
     >>> configure_feed config "galeries" "galeries de dessin/photo")
;;

let atom_for_journal (module R : Intf.RESOLVER) config { journal_entries; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.journal
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_file R.Source.journal_entries
     >>> R.track_common_deps
     >>> const journal_entries
     >>> configure_feed config "journal" "entrées du journal")
;;

let atom_for_tags (module R : Intf.RESOLVER) config { by_tags; _ } =
  Yocaml.Action.batch_list (M.bindings by_tags) (fun (tag, entries) ->
    let deps = List.map Model.Entry.file_of entries in
    Yocaml.Action.Static.write_file
      (R.Target.Atom.tag tag)
      (let open Yocaml.Task in
       Yocaml.Pipeline.track_files deps
       >>> R.track_common_deps
       >>> const entries
       >>> configure_feed config ("tags/" ^ tag) ("Flux du tag " ^ tag)))
;;
