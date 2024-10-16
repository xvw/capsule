module Make (R : Intf.RESOLVABLE) = struct
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let configuration = Path.(R.source / "capsule.toml")
    let content = Path.(R.source / "content")
    let assets = Path.(R.source / "assets")
    let cname = Path.(assets / "CNAME")
    let favicon = Path.(assets / "favicon")
    let templates = Path.(assets / "templates")
    let css = Path.(assets / "css")
    let fonts = Path.(assets / "fonts")
    let images = Path.(assets / "images")
    let indexes = Path.(content / "indexes")
    let pages = Path.(content / "pages")
    let deps = [ binary; configuration ]
    let template file = Path.(templates / file)
  end

  module Target = struct
    let root = R.target
    let promote p = Path.relocate ~into:root p
    let cache = Path.(R.source / "cache")
    let pages = Path.(R.target / "pages")
    let css = Path.(R.target / "css" / "capsule.css")
    let fonts = Path.(R.target / "fonts")
    let images = Path.(R.target / "images")
    let as_html file = file |> Path.change_extension "html"
    let as_page file = file |> as_html |> Path.move ~into:(Path.rel [ "pages" ])
    let as_index file = file |> as_html |> Path.move ~into:(Path.rel [])
  end

  let track_common_deps = Pipeline.track_files Source.deps
end
