include Yocaml.Required.DATA_READABLE
include Model.Types.MODEL with type t := t

val collapse_content : t -> string -> t
val date_of : t -> Yocaml.Datetime.t
val year_of : t -> int
