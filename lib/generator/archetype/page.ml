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
