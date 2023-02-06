type t

val default : t
val cost_per_byte : t -> Tez.t
val origination_size : t -> int
val encoding : t Data_encoding.t
