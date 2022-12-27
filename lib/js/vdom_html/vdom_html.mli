(** Some helper for defining UI element. *)

open Vdom

(** {1 Basic HTML nodes} *)

val text : ?key:string -> string -> 'msg vdom
val div : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val input : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val span : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val button : ('msg, 'msg vdom list -> 'msg vdom) elt_gen

(** {1 Basic HTML attributes} *)

val placeholder : string -> 'msg Vdom.attribute
