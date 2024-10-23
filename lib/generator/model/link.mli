type t

include Types.MODEL with type t := t

val make : string -> Url.t -> t
val equal : t -> t -> bool

val validate_from_url
  :  string
  -> Yocaml.Data.t
  -> t Yocaml.Data.Validation.validated_value

val url : t -> Url.t
val compare_title : t -> t -> int
