(** [Core_js] contains mostly useful and recurring features for front-end
    application development with OCaml. It is a kind of small standard library
    with usual functions. *)

(** {1 Common interfaces and types} *)

module Interfaces = Interfaces
module Aliases = Aliases

(** {1 Dealing with values that can be empty} *)

module Option = Option_stubs
module Nullable = Nullable_stubs
module Undefinedable = Undefinedable_stubs

type +'a or_null = 'a Nullable.t
(** A shortcut for defining value that can be null, so [int or_null] is
    equivalent to [int Js.Opt.t]. *)

type +'a or_undefined = 'a Undefinedable.t
(** A shortcut for defining value that can be undefined, so [int or_undefined]
    is equivalent to [int Js.Optef.t]. *)

(** {1 Dealing with the JS Console} *)

module Console = Console

(** {1 Dealing with storages} *)

module Storage : sig
  module Local = Local_storage
  module Session = Session_storage
end

include module type of Util
