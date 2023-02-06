type t

module Nano : sig
  val from_int : int -> t option
  val from_int64 : int64 -> t option
  val from_z : Z.t -> t option
  val from_int' : int -> t
  val from_int64' : int64 -> t
  val from_z' : Z.t -> t
  val one : t
end

module Micro : sig
  val from_int : int -> t option
  val from_int64 : int64 -> t option
  val from_z : Z.t -> t option
  val from_int' : int -> t
  val from_int64' : int64 -> t
  val from_z' : Z.t -> t
  val to_string : t -> string
  val one : t
end

val zero : t
val one : t
val from_int : int -> t option
val from_int64 : int64 -> t option
val from_z : Z.t -> t option
val from_int' : int -> t
val from_int64' : int64 -> t
val from_z' : Z.t -> t
val to_int64 : t -> int64
val to_z : t -> Z.t
val encoding : t Data_encoding.t
val pp : Format.formatter -> t -> unit
val to_string : t -> string
val from_string : string -> t option
val max : t -> t -> t
val ( + ) : t -> t -> t
val ( - ) : t -> t -> t option
val ( -! ) : t -> t -> t
val equal : t -> t -> bool
val compare : t -> t -> int
