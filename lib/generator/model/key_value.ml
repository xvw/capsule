open Model_util

module Make (K : Types.COMPARABLE_MODEL) (V : Types.MODEL) = struct
  module M = Stdlib.Map.Make (K)

  type key = K.t
  type value = V.t
  type t = value M.t

  let from_list = M.of_list
  let to_list = M.to_list
  let empty = M.empty

  let normalize kv =
    let open Yocaml.Data in
    kv
    |> to_list
    |> list_of (fun (key, value) ->
      record [ "key", K.normalize key; "value", V.normalize value ])
  ;;

  let as_record =
    let open Yocaml.Data in
    function
    | List [ k; v ] -> record [ "key", k; "value", v ]
    | x -> x
  ;;

  let validate =
    let open Yocaml.Data.Validation in
    list_of (fun x ->
      record
        (fun fields ->
           let+ key = required fields "key" K.validate
           and+ value = required fields "value" V.validate in
           key, value)
        (as_record x))
    $ from_list
  ;;

  let has_elements x = (not (M.is_empty x)) |> Yocaml.Data.bool
end

module String_model = struct
  type t = string

  let normalize = Yocaml.Data.string

  let validate =
    Yocaml.Data.Validation.(string & minimal_length ~length:String.length 1)
  ;;

  let compare = String.compare
end

module By_string = Make (String_model)
module String = By_string (String_model)
module Links = By_string (Link)
