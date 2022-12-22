(** A minimal binding of a FormData. *)

open Js_of_ocaml

type t = Bindings.form_data Js.t

val make : unit -> t
val append : t -> string -> string -> t
val delete : t -> string -> t
val get : t -> string -> string option
val has : t -> string -> bool
val set : t -> string -> string -> t
val get_all : t -> string -> string list
