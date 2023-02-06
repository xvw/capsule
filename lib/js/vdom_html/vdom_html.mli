(** Some helper for defining UI element. *)

open Vdom

(** {1 Basic HTML nodes} *)

val text : ?key:string -> string -> 'msg vdom
val div : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val input : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val span : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val button : ('msg, 'msg vdom list -> 'msg vdom) elt_gen
val label : ('msg, 'msg vdom list -> 'msg vdom) elt_gen

val tez_input :
  ( 'msg
  ,    min:Tezos_js.Tez.t
    -> max:Tezos_js.Tez.t
    -> step:Tezos_js.Tez.t
    -> unit
    -> 'msg vdom )
  elt_gen

(** {1 Basic HTML attributes} *)

val placeholder : string -> 'msg Vdom.attribute
val name : string -> 'msg Vdom.attribute
val id : string -> 'msg Vdom.attribute
val for_ : string -> 'msg Vdom.attribute
val checked : 'msg Vdom.attribute
