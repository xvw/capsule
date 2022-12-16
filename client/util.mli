(** Some helpers for dealing with Js interop. *)

open Js_of_ocaml

(** {1 Promise}

    Some helpers to deal with JavaScript's promises. *)

type +'a promise = 'a Promise.t

val promise_to_lwt : 'a promise -> 'a Lwt.t
val lwt_to_promise : 'a Lwt.t -> 'a promise

(** {1 Deal with JavaScript's array} *)

val list_to_js_array : ('a -> 'b) -> 'a list -> 'b Js.js_array Js.t
val js_array_to_list : ('a -> 'b) -> 'a Js.js_array Js.t -> 'b list
