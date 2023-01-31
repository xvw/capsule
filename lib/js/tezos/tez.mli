type t

val to_z : t -> Z.t
val of_tez : Z.t -> t
val of_mutez : Z.t -> t
val of_nanotez : Z.t -> t
val of_int : int -> t
val of_int_in_tez : int -> t
val of_int64 : Int64.t -> t
val of_int64_in_tez : Int64.t -> t
val to_tez_z : t -> Z.t
val zero : t
val pp : Format.formatter -> t -> unit
val to_string : t -> string
val encoding : t Data_encoding.t
val ( + ) : t -> t -> t
val plus : t -> t -> t
val max : t -> t -> t
val of_string_in_tez : string -> t option
