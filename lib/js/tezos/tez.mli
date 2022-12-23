type t

val of_z : Z.t -> t
val of_mutez : Z.t -> t
val pp : Format.formatter -> t -> unit
val to_string : t -> string
