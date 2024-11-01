include Types.ARCHETYPE

val replace_datetime : file:Yocaml.Path.t -> Input.t -> Input.t

val inject_datetime
  :  file:Yocaml.Path.t
  -> (Input.t * 'a, Input.t * 'a) Yocaml.Task.t

val compare_input : Input.t -> Input.t -> int
val rev_compare_input : Input.t -> Input.t -> int
val normalize_input : Input.t -> Yocaml.Data.t
