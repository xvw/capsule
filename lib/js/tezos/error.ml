let to_string = function
  | `Json_error str -> Format.asprintf "Json_error `%s`" str
  | `Json_exn exn ->
      Format.asprintf "Json_exn %a"
        (Data_encoding.Json.print_error ?print_unknown:None)
        exn
  | `Http_error code -> Format.asprintf "Http_error `%d`" code
  | `Address_invalid_prefix x -> Format.asprintf "Address_invalid_prefix %s" x
  | `Address_invalid_checksum x ->
      Format.asprintf "Address_invalid_checksum %s" x
  | `Address_invalid_length x -> Format.asprintf "Address_invalid_length %s" x
