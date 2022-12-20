type 'a fragment
type ('a, 'b) t

val k : string -> ('a, 'b) t -> ('a, 'b) t
val string : ('a, 'b) t -> (string -> 'a, 'b) t
val int : ('a, 'b) t -> (int -> 'a, 'b) t
val ( ~: ) : (('a, 'a) t -> ('b, 'c) t) -> ('b, 'c) t
val ( / ) : (('a, 'b) t -> 'c) -> ('d -> ('a, 'b) t) -> 'd -> 'c
val ( & ) : (unit -> 'a -> 'b) -> ('c -> 'a) -> 'c -> 'b
val sprintf_with : (string -> 'b) -> (unit -> ('a, 'b) t) -> 'a
val sprintf : (unit -> ('a, string) t) -> 'a
