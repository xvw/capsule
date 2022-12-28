type ('a, 'b) t = ('a, 'b) result = Ok of 'a | Error of 'b

val return : 'a -> ('a, 'b) t
val ok : 'a -> ('a, 'b) t
val error : 'b -> ('a, 'b) t
val map : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t
val bind : ('a -> ('b, 'c) t) -> ('a, 'c) t -> ('b, 'c) t
val map_ok : ('a -> 'b) -> ('a, 'c) t -> ('b, 'c) t
val map_error : ('a -> 'b) -> ('c, 'a) t -> ('c, 'b) t
val product : ('a, 'c) t -> ('b, 'c) t -> ('a * 'b, 'c) t
val fold : ok:('a -> 'c) -> error:('b -> 'c) -> ('a, 'b) t -> 'c

module Infix : sig
  val ( >|= ) : ('a, 'c) t -> ('a -> 'b) -> ('b, 'c) t
  val ( >>= ) : ('a, 'c) t -> ('a -> ('b, 'c) t) -> ('b, 'c) t
  val ( >|=! ) : ('c, 'a) t -> ('a -> 'b) -> ('c, 'b) t
end

include module type of Infix

module Syntax : sig
  val ( let+ ) : ('a, 'c) t -> ('a -> 'b) -> ('b, 'c) t
  val ( let* ) : ('a, 'c) t -> ('a -> ('b, 'c) t) -> ('b, 'c) t
  val ( let+! ) : ('c, 'a) t -> ('a -> 'b) -> ('c, 'b) t
  val ( and+ ) : ('a, 'c) t -> ('b, 'c) t -> ('a * 'b, 'c) t
end

include module type of Syntax
