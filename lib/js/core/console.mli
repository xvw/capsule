(** A Dead simple binding for the JavaScript's console. *)

open Js_of_ocaml

(** {1 Regular function} *)

val log : 'a -> unit
val debug : 'a -> unit
val info : 'a -> unit
val warn : 'a -> unit
val error : 'a -> unit
val trace : unit -> unit
val message : (Js.js_string Js.t -> unit) -> string -> unit

(** {1 Assertions} *)

val assertion : ?message:string -> ?payload:'a -> bool Js.t -> unit

(** {1 Structural representation} *)

val dir : 'a -> unit
val dir_xml : Dom.node Js.t -> unit
val table : ?columns:string list -> 'a -> unit

(** {2 Groups} *)

val group : ?collapsed:bool -> ?label:string -> unit -> unit
val group_end : unit -> unit

(** {1 Timers} *)

val time : ?label:string -> unit -> unit
val time_log : ?label:string -> 'a -> unit
val time_end : ?label:string -> unit -> unit

(** {1 Counters} *)

val count : ?label:string -> unit -> unit
val count_reset : ?label:string -> unit -> unit
