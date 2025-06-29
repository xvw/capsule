type t

val make
  :  (module Yocaml.Required.DATA_PROVIDER)
  -> (module Intf.RESOLVER)
  -> t Yocaml.Eff.t

val create_journal_feed
  :  (module Yocaml.Required.DATA_PROVIDER)
  -> (module Intf.RESOLVER)
  -> (string -> string)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

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

val atom_for_addresses
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_galleries
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_journal
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_english_articles
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_tags
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t

val atom_for_english_tags
  :  (module Intf.RESOLVER)
  -> Archetype.Config.t
  -> t
  -> Yocaml.Action.t
