(** A minimal binding of an HTTP Header. *)

open Js_of_ocaml

type t = Bindings.headers Js.t

val make : ?values:(string * string) list -> unit -> t
val append : t -> string -> string -> t
val delete : t -> string -> t
val get : t -> string -> string option
val has : t -> string -> bool
val set : t -> string -> string -> t
