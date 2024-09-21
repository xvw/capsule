type t

val validate : string -> t Yocaml.Data.Validation.validated_value
val normalize : t -> Yocaml.Data.t
val equal : t -> t -> bool
