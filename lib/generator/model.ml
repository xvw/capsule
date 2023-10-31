open Util
open Yocaml

module Effect_util = struct
  let read_metadata (type a) (module V : Metadata.VALIDABLE)
      (module R : Metadata.READABLE with type t = a) f path =
    let* content = read_file path in
    let result =
      let open Try.Monad in
      let* content = content in
      let m, _ = split_metadata content in

      R.from_string (module V) m |> Validate.to_try >|= f path
    in
    match result with Ok x -> return x | Error err -> throw err
end

module Atom_util = struct
  open Yocaml_syndication

  let domain = "https://xvw.lol"
  let into x = x |> into domain |> Uri.of_string
  let icon = "apple-touch-icon.png" |> into

  let date date =
    let (year, month, day), time = Yocaml.Date.to_pair date in
    let time = Option.value time ~default:(0, 0, 0) in
    Ptime.of_date_time ((year, Yocaml.Date.month_to_int month, day), (time, 0))
    |> Option.get (* Should never fail. *)

  let sort_by_date l =
    List.sort
      (fun (a : Syndic.Atom.entry) b -> Ptime.compare b.updated a.updated)
      l

  module Author = struct
    let make ?url ?email name =
      let open Preface.Option.Functor in
      let uri = Uri.of_string <$> url in
      Syndic.Atom.author ?uri ?email name

    let xvw =
      make ~url:domain ~email:"xaviervdw@gmail.com" "Xavier Van de Woestyne"

    let all = [ xvw ]
  end

  let txt v : Syndic.Atom.text_construct = Syndic.Atom.Text v
  let tags_to_category = List.map Syndic.Atom.category

  let header ~title ~subtitle ~id entries =
    let id = id |> into in
    let entries = sort_by_date entries in
    let updated = match entries with x :: _ -> x.updated | _ -> Ptime.epoch in
    Atom.make ~authors:Author.all ~title:(txt title) ~subtitle:(txt subtitle)
      ~logo:icon ~id
      ~links:[ Syndic.Atom.link ~rel:Syndic.Atom.Self ~hreflang:"fr" id ]
      ~updated entries

  let pp ppf feed =
    Syndic.Atom.to_xml feed
    |> Syndic.XML.to_string ~ns_prefix:(function
         | "http://www.w3.org/2005/Atom" -> Some ""
         | _ -> Some "http://www.w3.org/2005/Atom")
    |> String.cat {|<?xml version="1.0" encoding="UTF-8"?>|}
    |> Format.pp_print_string ppf

  let to_string feed = Format.asprintf "%a" pp feed
end

module Date_filename = struct
  let from_filename filename =
    let filename = filename |> Filepath.basename |> Filepath.remove_extension in
    match String.split_on_char '_' filename with
    | date_str :: time_str :: _tail ->
        let datetime_str =
          date_str ^ " " ^ String.map (function '-' -> ':' | x -> x) time_str
        in
        Date.from_string datetime_str
        |> Validate.Functor.map (fun date -> (filename, date))
    | _ -> Error.(to_validate @@ Invalid_date filename)

  let from_filename_opt filename =
    match from_filename filename with
    | Preface.Validation.Valid x -> Some x
    | _ -> None
end

module KVMap = struct
  type t = { key : string; value : string }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ key = Meta.(required_assoc string) "key" assoc
      and+ value = Meta.(required_assoc string) "value" assoc in
      { key; value }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { key; value } =
    let open Lang in
    [ ("key", string key); ("value", string value) ]

  let inject_list (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      =
    List.map (fun l -> Lang.object_ $ inject (module Lang) l)
end

module Link = struct
  type t = {
      name : string
    ; href : string
    ; title : string option
    ; description : string option
  }

  let make ?title ?description name href = { title; description; name; href }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ name = Meta.(required_assoc string) "name" assoc
      and+ href = Meta.(required_assoc string) "href" assoc
      and+ title = Meta.(optional_assoc string) "title" assoc
      and+ description = Meta.(optional_assoc string) "description" assoc in
      { name; href; title; description }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { name; href; title; description } =
    let open Lang in
    [
      ("name", string name)
    ; ("href", string href)
    ; ("title", Option.fold ~none:null ~some:string title)
    ; ("description", Option.fold ~none:null ~some:string description)
    ; ("has_title", boolean $ Option.is_some title)
    ; ("has_description", boolean $ Option.is_some description)
    ]

  let inject_list (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      =
    List.map (fun l -> Lang.object_ $ inject (module Lang) l)

  let compare { name = name_a; _ } { name = name_b; _ } =
    String.compare name_a name_b
end

module Index = struct
  type t = { name : string; synopsis : string; links : Link.t list }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    let validation assoc =
      let open Validate.Applicative in
      let+ name = Meta.(required_assoc string) "name" assoc
      and+ synopsis = Meta.(required_assoc string) "synopsis" assoc
      and+ sort = Meta.(optional_assoc_or ~default:false boolean) "sort" assoc
      and+ links =
        Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
          "links" assoc
      in

      {
        name
      ; synopsis
      ; links = (if sort then List.sort Link.compare links else links)
      }
    in
    Meta.object_and validation metadata_object

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { name; synopsis; links } =
    let open Lang in
    [
      ("name", string name)
    ; ("synopsis", string synopsis)
    ; ("links", list $ Link.inject_list (module Lang) links)
    ; ("anchor", string $ poor_slug name)
    ]

  let inject_list (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      =
    List.map (fun l -> Lang.object_ $ inject (module Lang) l)
end

module Page = struct
  type t = {
      title : string
    ; description : string
    ; breadcrumb : Link.t list
    ; synopsis : string
    ; indexed : bool
    ; tags : string list
    ; creation_date : Date.t option
    ; update_date : Date.t option
    ; toc : string option
    ; display_toc : bool
    ; indexes : Index.t list
  }

  let compute_url = Target.for_page ~target:""

  let to_atom file page =
    let open Preface.Option.Monad in
    let+ date =
      Preface.Option.Alternative.(page.update_date <|> page.creation_date)
    in
    let id = compute_url file |> Atom_util.into in
    let links = Syndic.Atom.[ link ~rel:Alternate ~hreflang:"fr" id ] in
    let published = page.creation_date >|= Atom_util.date in
    let authors = (Atom_util.Author.xvw, []) in
    let updated = Atom_util.date date in
    let categories = Atom_util.tags_to_category page.tags in
    let title = Atom_util.txt page.title in
    let summary = Atom_util.txt page.synopsis in
    Syndic.Atom.entry ?published ~updated ~authors ~categories ~links ~id ~title
      ~summary ()

  let map_synopsis arr =
    let open Build in
    (fun meta -> (meta.synopsis, meta)) ^>> fst arr >>^ fun (synopsis, m) ->
    { m with synopsis }

  let update_breadcrumb f page = { page with breadcrumb = f page.breadcrumb }

  let inject_toc =
    Build.arrow (fun (meta, (toc, content)) ->
        ({ meta with toc = Some toc }, content))

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let date = Metadata.Date.from (module Meta) in
    let open Validate.Applicative in
    let+ title =
      Meta.(optional_assoc_or ~default:"Page sans titre" string) "title" assoc
    and+ description =
      Meta.(optional_assoc_or ~default:"Page sans description" string)
        "description" assoc
    and+ synopsis =
      Meta.(optional_assoc_or ~default:"Page sans synopsis" string)
        "synopsis" assoc
    and+ indexed =
      Meta.(optional_assoc_or ~default:true boolean) "indexed" assoc
    and+ display_toc =
      Meta.(optional_assoc_or ~default:true boolean) "toc" assoc
    and+ creation_date = Meta.(optional_assoc date) "creation_date" assoc
    and+ update_date = Meta.(optional_assoc date) "update_date" assoc
    and+ tags =
      Meta.(optional_assoc_or ~default:[] (list_of string)) "tags" assoc
    and+ breadcrumb =
      Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
        "breadcrumb" assoc
    and+ indexes =
      Meta.(optional_assoc_or ~default:[] (list_of $ Index.from (module Meta)))
        "indexes" assoc
    in
    {
      title
    ; description
    ; breadcrumb
    ; synopsis
    ; indexed
    ; creation_date
    ; update_date
    ; tags = List.map String.trim tags
    ; toc = None
    ; display_toc
    ; indexes
    }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Page" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      {
        title
      ; description
      ; breadcrumb
      ; synopsis
      ; indexed
      ; creation_date
      ; update_date
      ; tags
      ; toc
      ; display_toc
      ; indexes
      } =
    let open Lang in
    let date x = object_ $ Metadata.Date.inject (module Lang) x in
    let has_toc = Option.is_some toc in
    [
      ("title", string title)
    ; ("description", string description)
    ; ("synopsis", string synopsis)
    ; ("indexed", boolean indexed)
    ; ("tags", list $ List.map string tags)
    ; ("creation_date", Option.fold ~none:null ~some:date creation_date)
    ; ("update_date", Option.fold ~none:null ~some:date update_date)
    ; ("breadcrumb", list $ Link.inject_list (module Lang) breadcrumb)
    ; ("indexes", list $ Index.inject_list (module Lang) indexes)
    ; ("has_indexes", boolean $ is_not_empty_list indexes)
    ; ("has_breadcrumb", boolean $ is_not_empty_list breadcrumb)
    ; ("has_tags", boolean $ is_not_empty_list tags)
    ; ("has_creation_date", boolean $ Option.is_some creation_date)
    ; ("has_update_date", boolean $ Option.is_some update_date)
    ; ("has_toc", boolean has_toc)
    ; ("display_toc", boolean (display_toc && has_toc))
    ; ("html_title", string title)
    ; ("html_meta_description", string description)
    ; ("html_meta_keywords", string $ String.concat ", " ("capsule" :: tags))
    ; ("toc", Option.fold ~none:null ~some:string toc)
    ]
end

module type ATTACH_PAGE = sig
  type t

  val get_page : t -> Page.t
  val set_page : Page.t -> t -> t
end

module type WITH_PAGE = sig
  type t

  val map_synopsis : (string, string) Build.t -> (t, t) Build.t
end

module Attach_page (P : ATTACH_PAGE) = struct
  let map_synopsis arr =
    let open Build in
    (fun meta -> (P.get_page meta, meta)) ^>> fst (Page.map_synopsis arr)
    >>^ fun (new_page, meta) -> P.set_page new_page meta
end

module Entry = struct
  type t = {
      page : Page.t
    ; date : Date.t
    ; date_str : string
    ; cover : string option
    ; meta : KVMap.t list
  }

  let compute_url = Target.for_entry ~target:""

  let to_atom entry =
    let pdate = Atom_util.date entry.date in
    let id = compute_url entry.date_str |> Atom_util.into in
    let links = Syndic.Atom.[ link ~rel:Alternate ~hreflang:"fr" id ] in
    let title =
      entry.page.title ^ ": " ^ String.concat ", " entry.page.tags
      |> Atom_util.txt
    in
    let authors = (Atom_util.Author.xvw, []) in
    let categories = Atom_util.tags_to_category entry.page.tags in
    let summary =
      Atom_util.txt
      @@ "entrée du journal pour le "
      ^ Format.asprintf "%a" Date.pp entry.date
    in
    Syndic.Atom.entry ~id ~title ~links ~authors ~categories ~summary
      ~published:pdate ~updated:pdate ()

  include Attach_page (struct
    type nonrec t = t

    let get_page { page; _ } = page
    let set_page page entry = { entry with page }
  end)

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let open Validate.Applicative in
    let date_str = "2023-01-01_10-00-00" in
    let+ date = Date.(make 2023 Jan 1)
    and+ page = Page.validate (module Meta) assoc
    and+ meta =
      Meta.(optional_assoc_or ~default:[] (list_of $ KVMap.from (module Meta)))
        "meta" assoc
    and+ cover = Meta.(optional_assoc string "cover" assoc) in
    let page =
      Page.update_breadcrumb (fun _ -> Link.[ make "Journal" "/journal/" ]) page
    in
    { page; date; cover; meta; date_str }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Entry" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { page; date; cover; meta; date_str } =
    let inject_date x = Lang.object_ $ Metadata.Date.inject (module Lang) x in
    Page.inject (module Lang) page
    @ Lang.
        [
          ("date", inject_date date)
        ; ("cover", Option.fold ~none:null ~some:string cover)
        ; ("meta", list $ KVMap.inject_list (module Lang) meta)
        ; ("has_meta", boolean $ is_not_empty_list meta)
        ; ("has_cover", boolean $ Option.is_some cover)
        ; ("entry_url", string (compute_url date_str))
        ]

  let inject_raw_date file date =
    let date_str = Date.to_string date in
    let title = date_str and synopsis = "Entrée du " ^ date_str in
    Build.arrow (fun entry ->
        {
          entry with
          date
        ; date_str = file
        ; page = { entry.page with title; synopsis; description = synopsis }
        })
end

module Entries = struct
  type entry = { entry : Entry.t; content : string }

  type t = {
      page : Page.t
    ; previous : int option
    ; next : int option
    ; entries : entry list
  }

  let build_entries files size =
    let sorted =
      List.filter_map
        (fun str ->
          match Date_filename.from_filename str with
          | Preface.Validation.Valid (_, date) -> Some (date, str)
          | _ -> None)
        files
      |> List.sort (fun (y, _) (x, _) -> Date.compare x y)
      |> split_by_size size
    in

    let length = List.length sorted in
    (length, sorted)

  let get_entries path size =
    let+ files = read_child_files path File.is_markdown in
    build_entries files size

  let get_entries_for_feed path size =
    let+ files = read_child_files path File.is_markdown in
    let _, sorted = build_entries files size in
    match sorted with [] -> [] | x :: _ -> x

  let read_entries_for_feed (module V : Metadata.VALIDABLE) entries =
    let open Build in
    List.fold_left
      (fun pre_arrow (date, entry_file) ->
        pre_arrow
        >>^ (fun x -> (x, ()))
        >>> snd
              (read_file_with_metadata (module V) (module Entry) entry_file
              >>> fst (Entry.inject_raw_date entry_file date))
        >>^ fun (acc, (entry, _)) -> Entry.to_atom entry :: acc)
      (arrow (fun _ -> []))
      entries
    >>^ List.rev

  let read_entries (module V : Metadata.VALIDABLE) length index arr entries =
    let open Build in
    let pre_arrow =
      List.fold_left
        (fun pre_arrow (date, entry_file) ->
          pre_arrow
          >>^ (fun x -> (x, ()))
          >>> snd
                (read_file_with_metadata (module V) (module Entry) entry_file
                >>> fst (Entry.inject_raw_date entry_file date)
                >>> snd arr)
          >>^ fun (acc, (entry, content)) -> { entry; content } :: acc)
        (arrow (fun _ -> []))
        entries
    in
    (fun (x, _) -> (x, ())) ^>> snd pre_arrow >>^ fun (page, entries) ->
    let previous = if index = 1 then None else Some (index - 1)
    and next = if index = length then None else Some (index + 1) in
    ({ page; entries = List.rev entries; next; previous }, "")

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { page; entries; next; previous } =
    Page.inject (module Lang) page
    @ Lang.
        [
          ("has_previous", boolean $ Option.is_some previous)
        ; ("has_next", boolean $ Option.is_some next)
        ; ("previous", Option.fold ~none:null ~some:integer previous)
        ; ("next", Option.fold ~none:null ~some:integer next)
        ; ( "entries"
          , list
            $ List.map
                (fun { entry; content } ->
                  object_
                    (("content", string content)
                    :: Entry.inject (module Lang) entry))
                entries )
        ]

  let preapply_for_one =
    Build.arrow (fun (e, s) ->
        match e.entries with
        | [ entry ] -> ({ e with page = entry.entry.page }, s)
        | _ -> (e, s))
end

module Address = struct
  type t = {
      page : Page.t
    ; country : string
    ; city : string
    ; zipcode : string
    ; address : string
    ; additional_fields : KVMap.t list
    ; nominatim_address : string
  }

  let compute_url = Target.for_address ~target:""

  let to_atom file address =
    let id = compute_url file |> Atom_util.into in
    let links = Syndic.Atom.[ link ~rel:Alternate ~hreflang:"fr" id ] in
    let open Preface.Option.Monad in
    let+ p = Page.to_atom file address.page in
    Syndic.Atom.{ p with id; links }

  let nominatim_address country city zipcode address =
    let address = poor_slug ~space:"+" address
    and country = poor_slug ~space:"+" country
    and city = poor_slug ~space:"+" city in
    Format.asprintf "street=%s&city=%s&country=%s&postalcode=%s" address city
      country zipcode

  include Attach_page (struct
    type nonrec t = t

    let get_page { page; _ } = page
    let set_page page address = { address with page }
  end)

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let open Validate.Applicative in
    let+ page = Page.validate (module Meta) assoc
    and+ country = Meta.(required_assoc string) "country" assoc
    and+ city = Meta.(required_assoc string) "city" assoc
    and+ zipcode = Meta.(required_assoc string) "zipcode" assoc
    and+ address = Meta.(required_assoc string) "address" assoc
    and+ additional_fields =
      Meta.(optional_assoc_or ~default:[] (list_of $ KVMap.from (module Meta)))
        "additional_fields" assoc
    in
    {
      page
    ; country
    ; city
    ; zipcode
    ; address
    ; additional_fields
    ; nominatim_address = nominatim_address country city zipcode address
    }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Address" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      {
        page
      ; country
      ; city
      ; zipcode
      ; address
      ; additional_fields
      ; nominatim_address
      } =
    Page.inject (module Lang) page
    @ Lang.
        [
          ("country", string country)
        ; ("city", string city)
        ; ("zipcode", string zipcode)
        ; ("address", string address)
        ; ( "additional_fields"
          , list $ KVMap.inject_list (module Lang) additional_fields )
        ; ("nominatim_address", string nominatim_address)
        ]
end

module Dapp = struct
  type t = { page : Page.t; addresses : Link.t list; manifest : string }

  include Attach_page (struct
    type nonrec t = t

    let get_page { page; _ } = page
    let set_page page dapp = { dapp with page }
  end)

  let validate (type a) (module Meta : Metadata.VALIDABLE with type t = a) assoc
      =
    let open Validate.Applicative in
    let+ page = Page.validate (module Meta) assoc
    and+ addresses =
      Meta.(optional_assoc_or ~default:[] (list_of $ Link.from (module Meta)))
        "addresses" assoc
    in
    { page; addresses; manifest = "" }

  let from (type a) (module Meta : Metadata.VALIDABLE with type t = a)
      metadata_object =
    Meta.object_and (validate (module Meta)) metadata_object

  let from_string (module Meta : Metadata.VALIDABLE) = function
    | None -> Error.(to_validate $ Required_metadata [ "Dapp" ])
    | Some str ->
        let open Validate.Monad in
        let* metadata = Meta.from_string str in
        from (module Meta) metadata

  let inject (type a) (module Lang : Key_value.DESCRIBABLE with type t = a)
      { page; addresses; manifest } =
    Page.inject (module Lang) page
    @ Lang.
        [
          ("addresses", list $ Link.inject_list (module Lang) addresses)
        ; ("manifest", string manifest)
        ]

  let join_files =
    Build.arrow (fun (html, (dapp, manifest)) -> ({ dapp with manifest }, html))

  let map_manifest arr =
    let open Build in
    (fun meta -> (meta.manifest, meta)) ^>> fst arr >>^ fun (manifest, m) ->
    { m with manifest }
end

module Feed = struct
  let get_page_for_feed (module V : Metadata.VALIDABLE) path size =
    let* files = read_child_files path File.is_markdown in
    let+ files =
      Traverse.traverse
        (Effect_util.read_metadata
           (module V)
           (module Page)
           (fun path e -> (path, Page.compute_url path, e)))
        files
    in
    let deps, entries =
      files
      |> List.filteri (fun i _ -> i < size)
      |> List.filter_map (fun (p, u, e) ->
             Option.map (fun x -> (Deps.file p, x)) (Page.to_atom u e))
      |> List.split
    in
    let deps = Deps.of_list deps in
    Build.make deps (fun () -> return entries)

  let get_addresses_for_feed (module V : Metadata.VALIDABLE) path size =
    let* files = read_child_files path File.is_markdown in
    let+ files =
      Traverse.traverse
        (Effect_util.read_metadata
           (module V)
           (module Address)
           (fun path e -> (path, Address.compute_url path, e)))
        files
    in
    let deps, entries =
      files
      |> List.filteri (fun i _ -> i < size)
      |> List.filter_map (fun (p, u, e) ->
             Option.map (fun x -> (Deps.file p, x)) (Address.to_atom u e))
      |> List.split
    in
    let deps = Deps.of_list deps in
    Build.make deps (fun () -> return entries)

  let pages (module V : Metadata.VALIDABLE) ~feed_file path size =
    let+ entries = get_page_for_feed (module V) path size in
    let open Build in
    entries
    >>^ (fun entries ->
          Atom_util.header ~title:"xvw.pages" ~subtitle:"Pages et articles"
            ~id:feed_file entries)
    >>^ Atom_util.to_string

  let addresses (module V : Metadata.VALIDABLE) ~feed_file path size =
    let+ entries = get_addresses_for_feed (module V) path size in
    let open Build in
    entries
    >>^ (fun entries ->
          Atom_util.header ~title:"xvw.addresses"
            ~subtitle:"Opinions sur des adresses" ~id:feed_file entries)
    >>^ Atom_util.to_string

  let journal (module V : Metadata.VALIDABLE) ~feed_file path size =
    let+ entries = Entries.get_entries_for_feed path size in
    let open Build in
    Entries.read_entries_for_feed (module V) entries
    >>^ (fun entries ->
          Atom_util.header ~title:"xvw.journal" ~subtitle:"Entrées du journal"
            ~id:feed_file entries)
    >>^ Atom_util.to_string

  let all (module V : Metadata.VALIDABLE) ~feed_file ~path_pages ~path_addresses
      ~path_journal size =
    let* journal =
      Entries.get_entries_for_feed path_journal size
      >|= Entries.read_entries_for_feed (module V)
    in
    let* pages = get_page_for_feed (module V) path_pages size in
    let+ addresses = get_addresses_for_feed (module V) path_addresses size in
    let open Build in
    (fun () -> ((), ((), ()))) ^>> fst journal
    >>> snd (fst pages >>> snd addresses)
    >>^ (fun (j, (p, a)) ->
          Atom_util.header ~title:"xvw" ~subtitle:"Fil complet d'actualité"
            ~id:feed_file
            (j @ p @ a))
    >>^ Atom_util.to_string
end
