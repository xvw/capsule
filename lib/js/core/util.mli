open Aliases
open Js_of_ocaml

(** {1 Dealing with promises}

    Js_of_ocaml does not provide binding, by default with promises so [Core_js]
    relies on [promise-jsoo] to handle promises within projects. *)

type nonrec +'a promise = 'a promise
(** Describe a JavaScript's promise. *)

val as_lwt : 'a promise -> 'a Lwt.t
(** [as_lwt js_promise] will convert a JavaScript promise into a Lwt one. *)

val as_promise : 'a Lwt.t -> 'a promise
(** [as_promise lwt_promise] will convert a Lwt promise into a JavaScript one.*)

(** {1 Dealing JavaScript Arrays} *)

val as_js_array : ('a -> 'b) -> 'a array -> 'b Js.js_array Js.t
(** [as_js_array f arr] will transform a Caml array to a Js array applying [f]
    on each element. *)

val as_array : ('a -> 'b) -> 'a Js.js_array Js.t -> 'b array
(** [js_array_to_list f arr] will transform a JavaScript array to a Caml array
    applying [f] on each element. *)

val list_to_js_array : ('a -> 'b) -> 'a list -> 'b Js.js_array Js.t
(** [list_to_js_array f list] will transform a Caml list to a Js array applying
    [f] on each element. *)

val js_array_to_list : ('a -> 'b) -> 'a Js.js_array Js.t -> 'b list
(** [js_array_to_list f arr] will transform a JavaScript array to a Caml list
    applying [f] on each element. *)

(** {1 Function helpers} *)

val id : 'a -> 'a
val const : 'a -> 'b -> 'a
val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
val ( % ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b

(** {1 Hidden values}

    The dynamic and variable nature of JavaScript means that it is sometimes
    necessary to hide data using existentials! *)

type hidden = Hidden : 'a -> hidden

val hide : 'a -> hidden
