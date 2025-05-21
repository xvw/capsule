(** Tool for dealing with logs. *)

(** Create the now page. *)
val create_now_page
  :  (module Yocaml.Required.DATA_PROVIDER)
  -> (module Intf.RESOLVER)
  -> (string -> string)
  -> Archetype.Config.t
  -> Yocaml.Action.t
