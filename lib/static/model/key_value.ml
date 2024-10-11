open Model_util

module Make (K : Types.MODEL) (V : Types.MODEL) = struct
  type key = K.t
  type value = V.t
  type t = (key * value) list

  let from_list x = x
  let to_list x = x

  let normalize =
    let open Yocaml.Data in
    list_of (fun (key, value) ->
      record [ "key", K.normalize key; "value", V.normalize value ])
  ;;

  let validate =
    let open Yocaml.Data.Validation in
    list_of
      (record (fun fields ->
         let+ key = required fields "key" K.validate
         and+ value = required fields "value" V.validate in
         key, value))
  ;;
end

module String_model = struct
  type t = string

  let normalize = Yocaml.Data.string

  let validate =
    Yocaml.Data.Validation.(string & minimal_length ~length:String.length 1)
  ;;
end

module By_string = Make (String_model)
module String = By_string (String_model)
module Links = By_string (Link)
