type 'a fragment =
  | Record of { to_string : 'a -> string; repr : string }
  | Mod of (module Interfaces.PATH_FRAGMENT with type t = 'a)

let fragment repr to_string = Record { to_string; repr }

let fragment_module (type a)
    (module F : Interfaces.PATH_FRAGMENT with type t = a) =
  Mod (module F)

let fragment_to_string (type a) (fragment : a fragment) value =
  match fragment with
  | Record { to_string; _ } -> to_string value
  | Mod (module M : Interfaces.PATH_FRAGMENT with type t = a) -> M.path value

let string = fragment ":string" (fun x -> x)
let int = fragment ":int" string_of_int
let chain_id = fragment_module (module Chain_id)
let block_id = fragment_module (module Block_id)
let contract_id = fragment_module (module Contract_id)

type ('a, 'b) t =
  | Root : ('a, 'a) t
  | Const : ('a, 'b) t * string -> ('a, 'b) t
  | Hole : ('b, 'a -> 'c) t * 'a fragment -> ('b, 'c) t

let root = Root
let const p s = Const (p, s)
let hole p h = Hole (p, h)
let ( / ) p s = const p s
let ( /: ) p h = hole p h
let ( ~/ ) s = const root s
let ( ~/: ) h = hole root h
let ( ~: ) f = f ()

let sprintf_with =
  let rec aux : type a b. (string -> b) -> (a, b) t -> a =
   fun k -> function
    | Root -> k ""
    | Const (tail, x) -> aux (fun xs -> k (xs ^ "/" ^ x)) tail
    | Hole (tail, fragment) ->
        let to_string = fragment_to_string fragment in
        aux (fun xs x -> k (xs ^ "/" ^ to_string x)) tail
  in
  aux

let sprintf path = sprintf_with (fun x -> x) path
