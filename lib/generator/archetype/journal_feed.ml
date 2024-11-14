type t =
  { deps : Yocaml.Deps.t
  ; entries : (Journal_entry.Input.t * string) list
  ; prev : int option
  ; next : int option
  }

let on_entry_content t f =
  { t with entries = List.map (fun (a, b) -> a, f b) t.entries }
;;

let from_list per_page entries =
  let entries = Std.List.split_by_size per_page entries in
  let total_l = List.length entries in
  entries
  |> List.mapi (fun index entries ->
    let prev = if Int.equal index 0 then None else Some (pred index)
    and next = if Int.equal index total_l then None else Some (succ index)
    and deps, entries =
      entries
      |> List.map (fun (meta, content, file) -> file, (meta, content))
      |> List.split
    in
    let deps = Yocaml.Deps.from_list deps in
    { deps; entries; prev; next })
;;

let normalize_integer x =
  if Int.equal 0 x
  then Yocaml.Data.string "/journal/"
  else Yocaml.Data.string @@ Format.asprintf "/journal/%d.html" x
;;

let normalize_entry (entry, content) =
  let open Yocaml.Data in
  record
    [ "content", string content
    ; ( "kv"
      , Model.Key_value.String.normalize @@ Journal_entry.kv_from_input entry )
    ; ( "datetime"
      , Yocaml.Datetime.normalize @@ Journal_entry.datetime_from_input entry )
    ; ( "cover"
      , option Model.Cover.normalize @@ Journal_entry.cover_from_input entry )
    ; "tags", list_of string @@ Journal_entry.tags_from_input entry
    ; ( "indexes"
      , Model.Indexes.normalize @@ Journal_entry.indexes_from_input entry )
    ]
;;

let normalize { prev; next; entries; _ } =
  let open Yocaml.Data in
  record
    [ "prev", option normalize_integer prev
    ; "next", option normalize_integer next
    ; "entries", list_of normalize_entry entries
    ]
;;

let deps_of { deps; _ } = deps
