type t

val validate
  :  (string * Yocaml.Data.t) list
  -> t Yocaml.Data.Validation.validated_record

val normalize : t -> (string * Yocaml.Data.t) list
val inspect : t -> Types.common
