(** Actions for dealing with projects. *)

val create_project_page
  :  (module Yocaml.Required.DATA_PROVIDER)
  -> (module Intf.RESOLVER)
  -> (string -> string)
  -> Archetype.Config.t
  -> Kohai_model.Described_item.Set.t
  -> Yocaml.Path.t
  -> Yocaml.Action.t
