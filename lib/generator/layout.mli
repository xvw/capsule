(** Some helper to deal with the layout. *)

val as_static
  :  (module Intf.RESOLVER)
  -> (module Yocaml.Required.DATA_INJECTABLE with type t = 'a)
  -> string list
  -> ('a * string, 'a * string) Yocaml.Task.t

val as_dynamic
  :  (module Intf.RESOLVER)
  -> (module Yocaml.Required.DATA_INJECTABLE with type t = 'a)
  -> string list
  -> ( ('a * string) * Yocaml.Deps.t
       , ('a * string) * Yocaml.Deps.t )
       Yocaml.Task.t
