type t

val make
  :  title:string
  -> content_url:Yocaml.Path.t
  -> datetime:Yocaml.Datetime.t
  -> ?summary:string
  -> tags:string list
  -> file:Yocaml.Path.t
  -> unit
  -> t

val compare : t -> t -> int
val rev_compare : t -> t -> int
val to_atom : base_url:Url.t -> t -> Yocaml_syndication.Atom.entry
val file_of : t -> Yocaml.Path.t
val tags_of : t -> string list
