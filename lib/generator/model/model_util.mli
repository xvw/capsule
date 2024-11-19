val exists_from_opt : 'a option -> Yocaml.Data.t
val exists_from_list : 'a list -> Yocaml.Data.t

val minimal_length
  :  length:('a -> int)
  -> int
  -> 'a
  -> ('a, Yocaml.Data.Validation.value_error) result
