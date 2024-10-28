include Types.ARCHETYPE

val replace_datetime : file:Yocaml.Path.t -> Input.t -> Input.t

val inject_datetime
  :  file:Yocaml.Path.t
  -> (Input.t * 'a, Input.t * 'a) Yocaml.Task.t
