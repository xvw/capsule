open Js_of_ocaml

type t = Bindings.url_search_params Js.t
type constr = (Js.js_string Js.t Js.optdef -> t) Js.constr

let make ?param () =
  let constr : constr = Js.Unsafe.global##._FormData in
  let param = Undefinedable_stubs.(Js.string <$> from_option param) in
  new%js constr param

let append url_search_params x y =
  let x = Js.string x and y = Js.string y in
  let () = url_search_params##append x y in
  url_search_params

let delete url_search_params x =
  let x = Js.string x in
  let () = url_search_params##delete x in
  url_search_params

let get url_search_params x =
  let open Nullable_stubs in
  let x = Js.string x in
  Js.to_string <$> url_search_params##get x |> to_option

let has url_search_params x =
  let x = Js.string x in
  url_search_params##has x |> Js.to_bool

let set url_search_params x y =
  let x = Js.string x and y = Js.string y in
  let () = url_search_params##set x y in
  url_search_params

let get_all url_search_params x =
  let x = Js.string x in
  Util.js_array_to_list Js.to_string (url_search_params##getAll x)

let to_string url_search_params = url_search_params##toString |> Js.to_string

let sort url_search_params =
  let () = url_search_params##sort in
  url_search_params
