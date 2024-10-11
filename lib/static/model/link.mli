type t

val make : string -> Url.t -> t
val equal : t -> t -> bool
val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
val normalize : t -> Yocaml.Data.t

val validate_from_url
  :  string
  -> Yocaml.Data.t
  -> t Yocaml.Data.Validation.validated_value
