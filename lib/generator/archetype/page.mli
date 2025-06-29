include Types.ARCHETYPE

val input_to_entry
  :  (string -> string)
  -> Input.t
  -> Yocaml.Path.t
  -> Blog_entry.t
