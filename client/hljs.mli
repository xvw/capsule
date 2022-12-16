(** A minimalist utility to compose with Highlight.js (and colorize the source
    code of blog posts). *)

open Js_of_ocaml

(** {1 Types} *)

type t = Bindings.Hljs.hljs Js.t

(** {1 Functions} *)

val get : unit -> t
(** Retreive the object [window.hljs] exported from [hell.js]. *)

val mount : unit -> unit Lwt.t
(** Enable syntactic highlighting for all code occurence. *)
