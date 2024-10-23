module M = Map.Make (String)

type entry =
  { title : string
  ; content_url : Yocaml.Path.t
  ; datetime : Yocaml.Datetime.t
  ; summary : string option
  ; tags : string list
  ; file : Yocaml.Path.t
  }
[@@warning "-69"]

type t =
  { pages : entry list
  ; entries : entry list
  ; by_tags : entry list M.t
  }
[@@warning "-69"]

let entry ~title ~content_url ~datetime ~summary ~tags ~file =
  { title; content_url; datetime; summary; tags; file }
;;

let compare_entry b a = Yocaml.Datetime.compare a.datetime b.datetime

let entry_to_atom ~base_url { title; content_url; datetime; summary; tags; _ } =
  let open Yocaml_syndication in
  let path = Model.Url.from_path content_url in
  let id = Model.Url.resolve base_url path |> Model.Url.to_string in
  let links = [ Atom.alternate ~title id ] in
  let summary = Option.map Atom.text summary in
  let categories = List.map Category.make tags in
  let updated = Datetime.make datetime in
  let title = Atom.text title in
  Atom.entry ?summary ~links ~categories ~updated ~id ~title ()
;;

let page_to_entry ~file ~url page =
  let title = Archetype.Page.Parse.page_title page
  and datetime = Archetype.Page.Parse.page_datetime page
  and tags = Archetype.Page.Parse.page_tags page
  and summary = Archetype.Page.Parse.page_summary page |> Std.Option.return in
  entry ~title ~content_url:url ~datetime ~summary ~tags ~file
;;

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
        entry.tags)
    m
    source
;;

let sort_map m = M.map (List.sort compare_entry) m

let build_context pages =
  let entries = pages in
  { pages = List.sort compare_entry pages
  ; entries = List.sort compare_entry entries
  ; by_tags = M.empty |> compute_map_from_tags pages |> sort_map
  }
;;

let make (module P : Yocaml.Required.DATA_PROVIDER) (module R : Intf.RESOLVER) =
  let open Yocaml.Eff in
  let* pages =
    from_source
      (module P)
      (module Archetype.Page.Parse)
      ~on:`Source
      ~where:File.is_markdown
      ~to_entry:page_to_entry
      ~compute_link:R.Target.as_page
      R.Source.pages
  in
  return @@ build_context pages
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
    (entry_to_atom ~base_url)
;;

let atom_for_entries (module R : Intf.RESOLVER) config { entries; _ } =
  Yocaml.Action.Static.write_file
    R.Target.Atom.general
    (let open Yocaml.Task in
     Yocaml.Pipeline.track_file R.Source.pages
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
