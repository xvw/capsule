type t

val make
  :  ?date:Yocaml.Datetime.t
  -> title:string
  -> ?synopsis:string
  -> ?tags:string list
  -> Yocaml.Path.t
  -> t

val normalize : t -> Yocaml.Data.t
val compare : t -> t -> int
val sort : ?desc:bool -> t list -> t list
