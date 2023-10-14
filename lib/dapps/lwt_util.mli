val return : 'a -> 'a Lwt.t
val return_ok : 'a -> ('a, 'err) result Lwt.t
val return_error : 'err -> ('a, 'err) result Lwt.t
val map : ('a -> 'b) -> 'a Lwt.t -> 'b Lwt.t
val map_ok : ('a -> 'b) -> ('a, 'err) result Lwt.t -> ('b, 'err) result Lwt.t

val map_error :
  ('err -> 'err_b) -> ('a, 'err) result Lwt.t -> ('a, 'err_b) result Lwt.t

val bind : ('a -> 'b Lwt.t) -> 'a Lwt.t -> 'b Lwt.t

val bind_ok :
     ('a -> ('b, 'err) result Lwt.t)
  -> ('a, 'err) result Lwt.t
  -> ('b, 'err) result Lwt.t

module Infix : sig
  val ( >|= ) : 'a Lwt.t -> ('a -> 'b) -> 'b Lwt.t
  val ( >>= ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t

  val ( >|=? ) :
    ('a, 'err) result Lwt.t -> ('a -> 'b) -> ('b, 'err) result Lwt.t

  val ( >>=? ) :
       ('a, 'err) result Lwt.t
    -> ('a -> ('b, 'err) result Lwt.t)
    -> ('b, 'err) result Lwt.t

  val ( >|=! ) :
    ('a, 'err_a) result Lwt.t -> ('err_a -> 'err_b) -> ('a, 'err_b) result Lwt.t
end

include module type of Infix

module Syntax : sig
  val ( let+ ) : 'a Lwt.t -> ('a -> 'b) -> 'b Lwt.t
  val ( let* ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t

  val ( let+? ) :
    ('a, 'err) result Lwt.t -> ('a -> 'b) -> ('b, 'err) result Lwt.t

  val ( let*? ) :
       ('a, 'err) result Lwt.t
    -> ('a -> ('b, 'err) result Lwt.t)
    -> ('b, 'err) result Lwt.t

  val ( let+! ) :
    ('a, 'err_a) result Lwt.t -> ('err_a -> 'err_b) -> ('a, 'err_b) result Lwt.t
end

include module type of Syntax
