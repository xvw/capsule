type t

val make : Page.t -> Blog_entry.t list -> t
val normalize : t -> (string * Yocaml.Data.t) list
