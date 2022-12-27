let to_string = function
  | `Json_error str -> Format.asprintf "Json_error `%s`" str
  | `Json_exn exn ->
      Format.asprintf "Json_exn %a"
        (Data_encoding.Json.print_error ?print_unknown:None)
        exn
  | `Http_error code -> Format.asprintf "Http_error `%d`" code
