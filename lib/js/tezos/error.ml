let to_string = function
  | `Json_error str -> Format.asprintf "Json_error `%s`" str
  | `Http_error code -> Format.asprintf "Http_error `%d`" code
