(** Describe a chain_id that can be `main` or a specific hash. *)

type t

val main : t
val from_string : string -> t
val to_string : t -> string
val path : t -> string
val repr : string
