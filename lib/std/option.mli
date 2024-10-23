val return : 'a -> 'a option
val map : ('a -> 'b) -> 'a option -> 'b option
val bind : ('a -> 'b option) -> 'a option -> 'b option
val ap : ('a -> 'b) option -> 'a option -> 'b option
val or_ : 'a option -> 'a option -> 'a option
val zip : 'a option -> 'b option -> ('a * 'b) option

module Infix : sig
  val ( <$> ) : ('a -> 'b) -> 'a option -> 'b option
  val ( <*> ) : ('a -> 'b) option -> 'a option -> 'b option
  val ( >|= ) : 'a option -> ('a -> 'b) -> 'b option
  val ( >>= ) : 'a option -> ('a -> 'b option) -> 'b option
  val ( ** ) : 'a option -> 'b option -> ('a * 'b) option
  val ( <|> ) : 'a option -> 'a option -> 'a option
  val ( || ) : 'a option -> 'a -> 'a
end

module Syntax : sig
  val ( let+ ) : 'a option -> ('a -> 'b) -> 'b option
  val ( let* ) : 'a option -> ('a -> 'b option) -> 'b option
  val ( and+ ) : 'a option -> 'b option -> ('a * 'b) option
end

include module type of Infix
include module type of Syntax

val dump
  :  (Format.formatter -> 'a -> unit)
  -> Format.formatter
  -> 'a option
  -> unit
