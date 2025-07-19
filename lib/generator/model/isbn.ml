type t = string

let entity_name = "ISBN"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  string
  & (fun given ->
    String.fold_left
      (fun acc -> function
         | '0' .. '9' as c -> Result.map (fun acc -> acc ^ String.make 1 c) acc
         | '-' | '_' | ' ' | ':' | '\t' -> acc
         | _ -> fail_with ~given "Invalid ISBN")
      (Ok "")
      given)
  & where
      ~pp:Format.pp_print_string
      ~message:(Format.asprintf "[%s] has not the right size")
      (fun given ->
         let len = String.length given in
         Int.equal len 10 || Int.equal len 13)
;;

let isbn_repr_10 offset isbn =
  let i x = isbn.[offset + x] in
  Format.asprintf
    "%c-%c%c%c%c-%c%c%c%c-%c"
    (i 0)
    (i 1)
    (i 2)
    (i 3)
    (i 4)
    (i 5)
    (i 6)
    (i 7)
    (i 8)
    (i 9)
;;

let isbn_repr isbn =
  match String.length isbn with
  | 10 -> isbn_repr_10 0 isbn
  | 13 ->
    Format.asprintf "%c%c%c-%s" isbn.[0] isbn.[1] isbn.[2] (isbn_repr_10 3 isbn)
  | _ -> isbn
;;

let normalize isbn =
  let open Yocaml.Data in
  let tgt = Url.from_path (Yocaml.Path.abs [ "isbn"; isbn ])
  and src = "isbnsearch.org" |> Url.https in
  let url = Url.resolve src tgt in
  record
    [ "target", Url.normalize url
    ; "value", string isbn
    ; "repr", string (isbn_repr isbn)
    ]
;;
