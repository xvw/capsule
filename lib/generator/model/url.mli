type t

include Types.MODEL with type t := t

val http : string -> t
val https : string -> t
val gemini : string -> t
val from_path : Yocaml.Path.t -> t
val equal : t -> t -> bool
val get_url : ?with_scheme:bool -> t -> string
val resolve : t -> t -> t
val extension : t -> string
val to_string : t -> string
