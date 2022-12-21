(** Describe a block_id that can be `head` or a specific hash. *)

type t

val head : t
val from_string : string -> t
val to_string : t -> string
val path : t -> string
val repr : string
