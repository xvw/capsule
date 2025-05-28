module Make (R : Intf.RESOLVABLE) = struct
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let configuration = Path.(R.source / "capsule.toml")
    let kohai = Path.(R.source / "kohai")
    let content = Path.(R.source / "content")
    let assets = Path.(R.source / "assets")
    let cname = Path.(assets / "CNAME")
    let favicon = Path.(assets / "favicon")
    let templates = Path.(assets / "templates")
    let css = Path.(assets / "css")
    let js = Path.(R.source / "hell" / "_build")
    let fonts = Path.(assets / "fonts")
    let images = Path.(assets / "images")
    let diagrams = Path.(content / "diagrams")
    let d2 = Path.(diagrams / "d2")
    let content_images = Path.(content / "images")
    let indexes = Path.(content / "indexes")
    let pages = Path.(content / "pages")
    let talks = Path.(content / "talks")
    let addresses = Path.(content / "addresses")
    let galleries = Path.(content / "galleries")
    let journal_entries = Path.(content / "journal")
    let specifics = Path.(content / "specifics")
    let speaking = Path.(specifics / "speaking.md")
    let now = Path.(specifics / "now.md")
    let activity = Path.(specifics / "activity.md")
    let journal_feed = Path.(specifics / "journal.yml")
    let maps = Path.(content / "maps")
    let template file = Path.(templates / file)

    module Kohai = struct
      let root = kohai
      let state_of p = Path.(p / "state.rens")
      let page_of p = Path.(p / "page.md")
      let state = state_of kohai
      let logs = Path.(kohai / "logs" / "list")
      let last_logs = Path.(kohai / "logs" / "last_logs.rens")

      let log uuid =
        let uuid = Kohai_core.Uuid.to_string uuid in
        Path.(logs / uuid) |> Path.add_extension "rens"
      ;;

      let sectors = Path.(kohai / "sectors")
      let projects = Path.(kohai / "projects")

      module Project = struct
        let list = Path.(kohai / "list" / "projects.rens")
        let state_of = state_of
        let page_of = page_of
      end
    end

    let deps = [ binary; configuration; Kohai.state ]
  end

  module Target = struct
    let root = R.target
    let promote p = Path.relocate ~into:root p
    let cache = Path.(R.source / "cache")
    let pages = Path.(R.target / "pages")
    let css = Path.(R.target / "css" / "capsule.css")
    let js = Path.(R.target / "js")
    let fonts = Path.(R.target / "fonts")
    let images = Path.(R.target / "images")
    let maps = Path.(images / "maps")
    let tags = Path.(R.target / "tags")
    let speaking = Path.(R.target / "speaking.html")
    let now = Path.(R.target / "now" / "index.html")
    let activity = Path.(R.target / "activity.html")
    let as_html file = file |> Path.change_extension "html"
    let as_index file = file |> as_html |> Path.move ~into:(Path.rel [])
    let as_page file = file |> as_html |> Path.move ~into:(Path.rel [ "pages" ])

    let as_journal_entry file =
      file |> as_html |> Path.move ~into:(Path.rel [ "journal" ])
    ;;

    let as_journal_feed_page index =
      let journal_path = Path.rel [ "journal" ] in
      if Int.equal index 0
      then Path.(journal_path / "index.html")
      else Path.(journal_path / string_of_int index / "index.html")
    ;;

    let as_gallery file =
      file |> as_html |> Path.move ~into:(Path.rel [ "galleries" ])
    ;;

    let as_address file =
      file |> as_html |> Path.move ~into:(Path.rel [ "addresses" ])
    ;;

    let as_diagram file =
      file |> Path.change_extension "svg" |> Path.move ~into:images
    ;;

    module Atom = struct
      let general = Path.(R.target / "atom.xml")
      let pages = Path.(R.target / "pages.xml")
      let addresses = Path.(R.target / "addresses.xml")
      let galleries = Path.(R.target / "galleries.xml")
      let journal = Path.(R.target / "journal.xml")
      let tag name = Path.(tags / name) |> Path.add_extension "xml"
    end
  end

  let track_common_deps = Pipeline.track_files Source.deps
end
