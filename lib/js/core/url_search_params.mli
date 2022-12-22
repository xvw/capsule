(** A minimal binding of a URLSearchParams. *)

open Js_of_ocaml

type t = Bindings.url_search_params Js.t

val make : ?param:string -> unit -> t
val append : t -> string -> string -> t
val delete : t -> string -> t
val get : t -> string -> string option
val has : t -> string -> bool
val set : t -> string -> string -> t
val get_all : t -> string -> string list
val to_string : t -> string
val sort : t -> t
