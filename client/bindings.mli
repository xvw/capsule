(** JavaScript bindings and libraries exported by {i hell.js} *)

open Js_of_ocaml

(** A minimal binding for the Hightlight.js library. *)
class type hljs =
  object
    method highlightAll : unit Js.meth
  end
