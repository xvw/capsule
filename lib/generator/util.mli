(** Some recurrent tools. *)

val is_empty_list : 'a list -> bool
(** [is_empty_list l] return [true] if the list is empty [false] otherwise. *)

val is_not_empty_list : 'a list -> bool
(** [is_empty_list l] return [true] if the list is not empty [false] otherwise. *)

val poor_slug : ?space:string -> string -> string
(** [poor_slug str] try poorly to render a string like... an url. *)

val split_at : int -> 'a list -> 'a list * 'a list
val split_by_size : int -> 'a list -> 'a list list
