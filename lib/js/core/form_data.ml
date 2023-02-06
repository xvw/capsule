open Js_of_ocaml

type t = Bindings.form_data Js.t
type constr = (unit -> t) Js.constr

let make () =
  let constr : constr = Js.Unsafe.global##._FormData in
  new%js constr ()

let append form_data x y =
  let x = Js.string x and y = Js.string y in
  let () = form_data##append x y in
  form_data

let delete form_data x =
  let x = Js.string x in
  let () = form_data##delete x in
  form_data

let get form_data x =
  let open Nullable_stubs in
  let x = Js.string x in
  Js.to_string <$> form_data##get x |> to_option

let has form_data x =
  let x = Js.string x in
  form_data##has x |> Js.to_bool

let set form_data x y =
  let x = Js.string x and y = Js.string y in
  let () = form_data##set x y in
  form_data

let get_all form_data x =
  let x = Js.string x in
  Util.js_array_to_list Js.to_string (form_data##getAll x)
