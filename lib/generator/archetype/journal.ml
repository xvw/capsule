module Input = struct
  type t = { page : Raw.Input.t }

  let entity_name = "Journal"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page } = Raw.Input.to_entry ~file ~url page

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

let normalize { page; entries; length; index } =
  let pred = if Int.compare index 0 > 0 then None else Some (pred index) in
  let succ =
    if Int.compare index length >= 0 then None else Some (succ index)
  in
  let open Yocaml.Data in
  Raw.Output.normalize page
  @ [ "entries", list_of journal_entries entries
    ; "length", int length
    ; "index", int index
    ; "pred", option int pred
    ; "succ", option int succ
    ; "has_pred", Model.Model_util.exists_from_opt pred
    ; "has_pred", Model.Model_util.exists_from_opt succ
    ]
;;

(* let full_configure ~config ~source ~target ~on_synopsis = *)
(*   Yocaml.Task.Static.on_metadata *)
