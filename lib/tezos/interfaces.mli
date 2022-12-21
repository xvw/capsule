module type PATH_FRAGMENT = sig
  type t

  val path : t -> string
  val repr : string
end
