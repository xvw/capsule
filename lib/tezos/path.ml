type 'a fragment = { to_string : 'a -> string; repr : string }

type (_, _) t =
  | Eop : ('a, 'a) t
  | Const : string * ('a, 'b) t -> ('a, 'b) t
  | Var : 'a fragment * ('b, 'c) t -> ('a -> 'b, 'c) t

let eop = Eop
let ( ~: ) path = path eop
let const constant tail = Const (constant, tail)
let k = const
let mk_fragment to_string repr = { to_string; repr }
let mk_var tail fragment = Var (fragment, tail)
let string tail = mk_var tail @@ mk_fragment (fun x -> x) "string"
let int tail = mk_var tail @@ mk_fragment string_of_int "int"
let ( / ) l r tail = l (r tail)
let ( & ) l r = l () / r
(* let rr () = string / k "foo" / k "bar" / int / int / string *)
(* let ss () = ~:(rr & (k "baz" / int / string)) *)

let sprintf_with handler path =
  let rec aux : type a b. (string list -> b) -> (a, b) t -> a =
   fun resume -> function
    | Eop -> resume []
    | Const (x, tail) -> aux (fun xs -> resume (x :: xs)) tail
    | Var ({ to_string; _ }, tail) ->
        fun x -> aux (fun xs -> resume (to_string x :: xs)) tail
  in
  aux (fun result -> handler ("/" ^ String.concat "/" result ^ "")) (path ())

let sprintf path = sprintf_with (fun x -> x) path
