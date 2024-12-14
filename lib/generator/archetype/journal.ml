module Input = struct
  type t = { page : Raw.Input.t }

  let entity_name = "Journal"
  let neutral = Yocaml.Metadata.required entity_name

  let validate obj =
    let open Yocaml.Data.Validation in
    let+ page = Raw.Input.validate obj in
    { page }
  ;;
end

type t =
  { page : Raw.Output.t
  ; entries : (Journal_entry.Input.t * string * Yocaml.Path.t) list
  ; length : int
  ; index : int
  }

let journal_entries (entry, content, path) =
  let open Yocaml.Data in
  record
    [ "entry_content", string content
    ; "path", string @@ Yocaml.Path.to_string path
    ; "input", Journal_entry.normalize_input entry
    ]
;;

let normalize_index = function
  | 0 -> ""
  | x -> string_of_int x
;;

let normalize { page; entries; length; index } =
  let pred = if index <= 0 then None else Some (pred index) in
  let succ = if index >= length - 1 then None else Some (succ index) in
  let open Yocaml.Data in
  Raw.Output.normalize page
  @ [ "entries", list_of journal_entries entries
    ; "length", int length
    ; "index", int index
    ; "pred", option string (Option.map normalize_index pred)
    ; "succ", option string (Option.map normalize_index succ)
    ; "has_pred", Model.Model_util.exists_from_opt pred
    ; "has_succ", Model.Model_util.exists_from_opt succ
    ]
;;

let full_configure
      ~config
      ~source
      ~target
      ~kind
      ~on_synopsis
      ~length
      ~entries
      ~index
  =
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
     ; length
     ; entries =
         List.map
           (fun (meta, content, path) -> meta, on_synopsis content, path)
           entries
     ; index
     })
;;

let deps_of entries = List.map (fun (_, _, path) -> path) entries
