(** Currently only support Github and Gitlab (because it is for my own
    usage) *)

type t

include Types.MODEL with type t := t

val equal : t -> t -> bool
val resolve_path : ?branch:string -> Yocaml.Path.t -> t -> Url.t
