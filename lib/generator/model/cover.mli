type t

include Types.MODEL with type t := t

val meta_for : t -> Meta.t option list
val resolve : Url.t -> t -> t
