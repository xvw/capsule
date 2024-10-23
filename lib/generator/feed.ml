type entry =
  { title : string
  ; content_url : Yocaml.Path.t
  ; datetime : Yocaml.Datetime.t
  ; summary : string option
  ; tags : string list
  }

let entry ~title ~content_url ~datetime ~summary ~tags =
  { title; content_url; datetime; summary; tags }
;;

let entry_to_atom ~base_url { title; content_url; datetime; summary; tags } =
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

let page_to_entry (content_url, page) =
  let title = Archetype.Page.Parse.page_title page
  and datetime = Archetype.Page.Parse.page_datetime page
  and tags = Archetype.Page.Parse.page_tags page
  and summary = Archetype.Page.Parse.page_summary page |> Std.Option.return in
  entry ~title ~content_url ~datetime ~summary ~tags
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
        to_entry ~url metadata)
      files
  in
  elements
;;
