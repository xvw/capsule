type t

val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
val normalize : t -> Yocaml.Data.t
val meta_for : t -> Meta.t option list
val resolve : Url.t -> t -> t
