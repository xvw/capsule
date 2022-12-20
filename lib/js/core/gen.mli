(** Some functors that generalise recurrent behaviour. *)

(** Generates all syntaxic let-operators for Functor/Applicative and Monad. *)
module Preface_syntax
    (F : Preface.Specs.FUNCTOR)
    (A : Preface.Specs.APPLICATIVE with type 'a t = 'a F.t)
    (M : Preface.Specs.MONAD with type 'a t = 'a F.t) : sig
  module Syntax : Interfaces.LET_SYNTAX with type 'a t = 'a F.t
  include Interfaces.LET_SYNTAX with type 'a t := 'a Syntax.t
end

(** Generates all infix operators for Functor/Applicative/Alternative/Selective
    and Monad. *)
module Preface_infix
    (F : Preface.Specs.FUNCTOR)
    (A : Preface.Specs.APPLICATIVE with type 'a t = 'a F.t)
    (P : Preface.Specs.ALTERNATIVE with type 'a t = 'a F.t)
    (S : Preface.Specs.SELECTIVE with type 'a t = 'a F.t)
    (M : Preface.Specs.MONAD with type 'a t = 'a F.t) : sig
  module Infix : sig
    include Preface.Specs.Functor.INFIX
    include Preface.Specs.Applicative.INFIX with type 'a t := 'a t
    include Preface.Specs.Alternative.INFIX with type 'a t := 'a t
    include Preface.Specs.Selective.INFIX with type 'a t := 'a t
    include Preface.Specs.Monad.INFIX with type 'a t := 'a t
  end

  include module type of Infix
end

(** Builds the full OPTIONAL api with minimal requirements. *)
module Preface_optional (R : Interfaces.OPTIONAL_REQ) :
  Interfaces.OPTIONAL with type 'a t = 'a R.t

(** Dealing with storage. *)

module Storage (R : Interfaces.STORAGE_REQ) : Interfaces.STORAGE
