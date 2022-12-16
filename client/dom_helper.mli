(** Some helpers for dealing with the DOM. *)

open Js_of_ocaml

val clear_node : Dom_html.element Js.t -> unit
(** Clear a given HTML node. *)
