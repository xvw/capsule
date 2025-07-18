val split_by_size : int -> 'a list -> 'a list list

val textual_join
  :  (string -> [ `First | `Regular | `Last ] -> string)
  -> ('a -> string)
  -> 'a list
  -> string

val textual_enum : ?last:string -> ('a -> string) -> 'a list -> string
