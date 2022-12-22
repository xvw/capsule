open Js_of_ocaml

type t = Bindings.headers Js.t

type constr =
  (Js.js_string Js.t Js.js_array Js.t Js.js_array Js.t -> t) Js.constr

let make ?(values = []) () =
  let constr : constr = Js.Unsafe.global##._Headers in
  let js_values =
    Util.list_to_js_array
      (fun (x, y) -> Util.list_to_js_array Js.string [ x; y ])
      values
  in
  new%js constr js_values

let append headers x y =
  let x = Js.string x and y = Js.string y in
  let () = headers##append x y in
  headers

let delete headers x =
  let x = Js.string x in
  let () = headers##delete x in
  headers

let get headers x =
  let open Nullable_stubs in
  let x = Js.string x in
  Js.to_string <$> headers##get x |> to_option

let has headers x =
  let x = Js.string x in
  headers##has x |> Js.to_bool

let set headers x y =
  let x = Js.string x and y = Js.string y in
  let () = headers##set x y in
  headers
