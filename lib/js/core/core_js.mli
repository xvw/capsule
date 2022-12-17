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

(** {1 Dealing with promises}

    Js_of_ocaml does not provide binding, by default with promises so [Core_js]
    relies on [promise-jsoo] to handle promises within projects. *)

type +'a promise
(** Describe a JavaScript's promise. *)

val as_lwt : 'a promise -> 'a Lwt.t
(** [as_lwt js_promise] will convert a JavaScript promise into a Lwt one. *)

val as_promise : 'a Lwt.t -> 'a promise
(** [as_promise lwt_promise] will convert a Lwt promise into a JavaScript one.*)
