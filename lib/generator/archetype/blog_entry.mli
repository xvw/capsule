type t

val make
  :  ?date:Yocaml.Datetime.t
  -> title:string
  -> ?synopsis:string
  -> ?tags:string list
  -> unit
  -> t

val normalize : t -> Yocaml.Data.t
