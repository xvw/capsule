val print_validated_value
  :  (Format.formatter -> 'a -> unit)
  -> 'a Yocaml.Data.Validation.validated_value
  -> unit

val print_normalized_value
  :  ('a -> Yocaml.Data.t)
  -> ('a, Yocaml.Data.Validation.value_error) result
  -> unit
