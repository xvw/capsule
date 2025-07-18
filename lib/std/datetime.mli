val min_opt
  :  Yocaml.Datetime.t option
  -> Yocaml.Datetime.t
  -> Yocaml.Datetime.t option

val max_opt
  :  Yocaml.Datetime.t option
  -> Yocaml.Datetime.t
  -> Yocaml.Datetime.t option

val normalize_month : Yocaml.Datetime.t -> Yocaml.Data.t
