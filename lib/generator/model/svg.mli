type t

include Types.MODEL with type t := t

val normalize_list : t list -> Yocaml.Data.t
