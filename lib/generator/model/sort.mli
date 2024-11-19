type t =
  { key : Yocaml.Slug.t
  ; rev : bool
  }

include Types.MODEL with type t := t

val key : t -> Yocaml.Slug.t
val is_rev : t -> bool
