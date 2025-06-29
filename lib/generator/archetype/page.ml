module Input = struct
  type t = { page : Raw.Input.t }

  let entity_name = "Page"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page } = Raw.Input.to_entry ~file ~url page

  let validate obj =
    let open Yocaml.Data.Validation in
    let+ page = Raw.Input.validate obj in
    { page }
  ;;
end

let input_to_entry f Input.{ page } path =
  let date = Std.Option.(page#published_at <|> page#updated_at) in
  let title = page#page_title in
  let synopsis = page#synopsis |> Option.map f in
  let tags = page#tags in
  Blog_entry.make ?date ~title ?synopsis ~tags path
;;

type t = { page : Raw.Output.t }

let normalize { page } = Raw.Output.normalize page
let table_of_content { page } s = { page = Raw.Output.table_of_content page s }

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
     @@ fun Input.{ page } ->
     { page =
         Raw.Output.full_configure
           ~config
           ~source
           ~target
           ~kind
           ~on_synopsis
           page
     })
;;
