(** Some helper to deal with Markdown via Cmarkit. *)

val string_to_html : ?strict:bool -> ?safe:bool -> string -> string

val to_html
  :  ?strict:bool
  -> ?safe:bool
  -> unit
  -> (string, string) Yocaml.Task.t

val to_html_with_toc
  :  ?strict:bool
  -> ?safe:bool
  -> unit
  -> (string, string option * string) Yocaml.Task.t

val content_to_html_with_toc
  :  ?strict:bool
  -> ?safe:bool
  -> ('a -> string option -> 'b)
  -> ('a * string, 'b * string) Yocaml.Task.t

val content_to_html
  :  ?strict:bool
  -> ?safe:bool
  -> unit
  -> ('a * string, 'a * string) Yocaml.Task.t
