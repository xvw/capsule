type t

include Yocaml.Required.DATA_READABLE with type t := t

val normalize : t -> Yocaml.Data.t
val date_of : t -> Yocaml.Datetime.t
val period_of : t -> Yocaml.Datetime.year * Yocaml.Datetime.month
