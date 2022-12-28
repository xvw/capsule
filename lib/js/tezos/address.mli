type t = string

type error =
  [ `Address_invalid_prefix of string
  | `Address_invalid_checksum of string
  | `Address_invalid_length of string ]

val to_string : t -> string
val to_short_string : t -> string
val from_string : string -> t
val validate : t -> (t, error) result
val is_valid : t -> bool
val pp : Format.formatter -> t -> unit
