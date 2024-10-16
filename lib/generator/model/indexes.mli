type t = Index.t list

include Types.MODEL with type t := t

val map : (Index.t -> Index.t) -> t -> t
val empty : t
