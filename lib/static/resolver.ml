module Make (R : Intf.RESOLVABLE) = struct
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let configuration = Path.(R.source / "capsule.toml")
    let content = Path.(R.source / "content")
    let assets = Path.(R.source / "assets")
    let templates = Path.(assets / "templates")
    let css = Path.(assets / "css")
    let fonts = Path.(assets / "fonts")
    let images = Path.(assets / "images")
    let pages = Path.(content / "pages")
    let deps = [ binary; configuration ]
    let template file = Path.(templates / file)
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.source / "cache")
    let pages = Path.(R.target / "pages")
    let css = Path.(R.target / "css")
    let fonts = Path.(R.target / "fonts")
    let images = Path.(R.target / "images")

    let as_html ~into file =
      file |> Path.move ~into |> Path.change_extension "html"
    ;;
  end

  let track_common_deps = Pipeline.track_files Source.deps
end
