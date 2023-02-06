open Js_of_ocaml

type t = Bindings.text_decoder Js.t
type constr = (Js.js_string Js.t Js.optdef -> t) Js.constr

let make ?label () =
  let open Undefinedable_stubs in
  let label = Js.string <$> from_option label in
  let constr : constr = Js.Unsafe.global##._TextDecoder in
  new%js constr label

let decode decoder value = decoder##decode value |> Js.to_string
