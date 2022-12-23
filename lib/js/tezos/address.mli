type t = string

val to_string : t -> string
val to_short_string : t -> string
val from_string : string -> t
val pp : Format.formatter -> t -> unit
