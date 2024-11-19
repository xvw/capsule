type t

include Types.NORMALIZABLE with type t := t

val make : name:string -> content:string -> t
val from_option : string -> string option -> t option
val from_list : string -> string list -> t option
val normalize_options : t option list -> Yocaml.Data.t
