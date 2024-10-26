type t = (Yocaml.Datetime.t * string) list

include Types.MODEL with type t := t

val on_messages : (string -> string) -> t -> t
