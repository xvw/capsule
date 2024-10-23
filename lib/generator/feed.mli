type t

val make
  :  (module Yocaml.Required.DATA_PROVIDER)
  -> (module Intf.RESOLVER)
  -> t Yocaml.Eff.t

val atom_for_pages
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_entries
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t
