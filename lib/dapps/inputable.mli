type ('a, 'b) t

val empty : unit -> ('a, 'b) t
val is_asked : ('a, 'b) t -> bool
val error : ('a, 'b) t -> 'b option
val has_error : ('a, 'b) t -> bool
val is_valid : ('a, 'b) t -> bool
val is_valid_and : ('a, 'b) t -> ('a -> bool) -> bool
val get_result : ('a, 'b) t -> 'a option
val get_value : ('a, 'b) t -> string
val set_value : (string -> ('a, 'b) result) -> string -> ('a, 'b) t
val map : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t
val map_error : ('a -> 'b) -> ('c, 'a) t -> ('c, 'b) t
val bind : ('a -> ('b, 'c) result option) -> ('a, 'c) t -> ('b, 'c) t
val repr : ('a, 'b) t -> ('a, 'b) result option

module Infix : sig
  val ( >|= ) : ('a, 'c) t -> ('a -> 'b) -> ('b, 'c) t
  val ( >>= ) : ('a, 'c) t -> ('a -> ('b, 'c) result option) -> ('b, 'c) t
end

module Syntax : sig
  val ( let+ ) : ('a, 'c) t -> ('a -> 'b) -> ('b, 'c) t
  val ( let* ) : ('a, 'c) t -> ('a -> ('b, 'c) result option) -> ('b, 'c) t
end

include module type of Infix
include module type of Syntax
