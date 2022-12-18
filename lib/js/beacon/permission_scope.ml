open Js_of_ocaml
open Core_js

type t = ENCRYPT | OPERATION_REQUEST | SIGN | THRESHOLD

let to_string = function
  | ENCRYPT -> "encrypt"
  | OPERATION_REQUEST -> "operation_request"
  | SIGN -> "sign"
  | THRESHOLD -> "threshold"

let from_string str =
  match String.(trim (lowercase_ascii str)) with
  | "encrypt" -> Some ENCRYPT
  | "operation_request" -> Some OPERATION_REQUEST
  | "sign" -> Some SIGN
  | "threshold" -> Some THRESHOLD
  | _ -> None

let from_js_array scopes =
  js_array_to_list
    (fun x -> x |> Js.to_string |> from_string |> Option.to_list)
    scopes
  |> List.flatten

let to_js_array scopes =
  list_to_js_array (fun x -> x |> to_string |> Js.string) scopes
