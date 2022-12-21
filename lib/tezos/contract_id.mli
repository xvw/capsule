(** Describe a contract_id . *)

type t

val from_string : string -> t
val to_string : t -> string
val path : t -> string
val repr : string
