module type LET_SYNTAX = sig
  (** All let-syntax for [Functor]. [Applicative] and [Monad]. *)

  type 'a t

  val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
  val ( and+ ) : 'a t -> 'b t -> ('a * 'b) t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
end

module type OPTIONAL_REQ = sig
  type 'a t

  val empty : 'a t
  val return : 'a -> 'a t
  val fold : (unit -> 'b) -> ('a -> 'b) -> 'a t -> 'b
  val pp : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a t -> unit
end

module type OPTIONAL = sig
  (** An unified interface for [option], [null] and [unefined]. *)

  include OPTIONAL_REQ

  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val test : 'a t -> bool
  val value : default:'a -> 'a t -> 'a
  val if_ : ('a -> bool) -> 'a -> 'a t
  val unless : ('a -> bool) -> 'a -> 'a t
  val to_list : 'a t -> 'a list
  val to_option : 'a t -> 'a option
  val from_option : 'a option -> 'a t
  val to_nullable : 'a t -> 'a Js_of_ocaml.Js.opt
  val from_nullable : 'a Js_of_ocaml.Js.opt -> 'a t
  val to_undefinedable : 'a t -> 'a Js_of_ocaml.Js.optdef
  val from_undefinedable : 'a Js_of_ocaml.Js.optdef -> 'a t

  module Functor : Preface.Specs.FUNCTOR with type 'a t = 'a t
  module Alt : Preface.Specs.ALT with type 'a t = 'a t

  module Applicative :
    Preface.Specs.Traversable.API_OVER_APPLICATIVE with type 'a t = 'a t

  module Alternative : Preface.Specs.ALTERNATIVE with type 'a t = 'a t
  module Selective : Preface.Specs.SELECTIVE with type 'a t = 'a t
  module Monad : Preface.Specs.Traversable.API_OVER_MONAD with type 'a t = 'a t
  module Monad_plus : Preface.Specs.MONAD_PLUS with type 'a t = 'a t
  module Foldable : Preface.Specs.FOLDABLE with type 'a t = 'a t
  module Syntax : LET_SYNTAX with type 'a t = 'a t

  module Infix : sig
    include Preface.Specs.Functor.INFIX
    include Preface.Specs.Applicative.INFIX with type 'a t := 'a t
    include Preface.Specs.Alternative.INFIX with type 'a t := 'a t
    include Preface.Specs.Selective.INFIX with type 'a t := 'a t
    include Preface.Specs.Monad.INFIX with type 'a t := 'a t
  end

  include LET_SYNTAX with type 'a t := 'a t
  include module type of Infix with type 'a t := 'a t
end
