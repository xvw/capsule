type t

include Types.MODEL with type t := t

val compare_by_name : t -> t -> int
val compare_by_id : t -> t -> int