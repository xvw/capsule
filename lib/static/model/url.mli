type t

val http : string -> t
val https : string -> t
val gemini : string -> t
val from_path : Yocaml.Path.t -> t
val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
val normalize : t -> Yocaml.Data.t
val equal : t -> t -> bool
val get_url : ?with_scheme:bool -> t -> string
val resolve : t -> t -> t
val extension : t -> string
val to_string : t -> string
