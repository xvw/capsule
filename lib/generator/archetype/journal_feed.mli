type t

val from_list
  :  int
  -> (Journal_entry.Input.t * string * Yocaml.Path.t) list
  -> t list

val normalize : t -> Yocaml.Data.t
val deps_of : t -> Yocaml.Deps.t
val on_entry_content : t -> (string -> string) -> t
