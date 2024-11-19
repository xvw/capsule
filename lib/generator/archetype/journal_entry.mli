include Types.ARCHETYPE

val replace_datetime : file:Yocaml.Path.t -> Input.t -> Input.t

val inject_datetime
  :  file:Yocaml.Path.t
  -> (Input.t * 'a, Input.t * 'a) Yocaml.Task.t

val compare_input : Input.t -> Input.t -> int
val rev_compare_input : Input.t -> Input.t -> int
val normalize_input : Input.t -> Yocaml.Data.t
val kv_from_input : Input.t -> Model.Key_value.String.t
val datetime_from_input : Input.t -> Yocaml.Datetime.t
val cover_from_input : Input.t -> Model.Cover.t option
val tags_from_input : Input.t -> string list
val indexes_from_input : Input.t -> Model.Indexes.t
