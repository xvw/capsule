type t = Int64.t

module Nano = struct
  let from_int64 x = if Int64.compare x 0L < 0 then None else Some x
  let from_int x = from_int64 (Int64.of_int x)
  let from_z x = from_int64 (Z.to_int64 x)
  let from_int' = Int64.of_int
  let from_int64' x = x
  let from_z' x = from_int64' (Z.to_int64 x)
  let one = 1L
end

module Micro = struct
  let one = 1000L

  let from_int64 x =
    let open Core_js.Option.Syntax in
    let+ x = Nano.from_int64 x in
    Int64.mul x one

  let from_int x = from_int64 (Int64.of_int x)
  let from_z x = from_int64 (Z.to_int64 x)
  let from_int64' = Int64.mul one
  let from_int' x = from_int64' (Int64.of_int x)
  let from_z' x = from_int64' (Z.to_int64 x)
  let to_string x = Int64.div x one |> Int64.to_string
end

let zero = 0L
let one = Int64.mul 1_000_000L Micro.one

let from_int64 x =
  let open Core_js.Option.Syntax in
  let+ x = Nano.from_int64 x in
  Int64.mul x one

let from_int x = from_int64 (Int64.of_int x)
let from_z x = from_int64 (Z.to_int64 x)
let from_int64' x = Int64.mul x one
let from_int' x = from_int64' (Int64.of_int x)
let from_z' x = from_int64' (Z.to_int64 x)
let to_int64 x = x
let to_z = Z.of_int64

let encoding =
  let open Data_encoding in
  let decode = to_z
  and encode = Json.wrap_error (fun i -> Micro.from_int64' @@ Z.to_int64 i) in
  def "mutez" (check_size 10 (conv decode encode n))

let pp ppf x =
  let left = Int64.div x one
  and right = Int64.div (Int64.rem x one) Micro.one in
  Format.fprintf ppf "%Li.%06Li" left right

let to_string = Format.asprintf "%a" pp
let max = Int64.max

let decimal_from_string decimal =
  let open Core_js.Option.Syntax in
  let* p =
    match String.length decimal with
    | 0 -> Some Int64.zero
    | 1 -> Some 100_000L
    | 2 -> Some 10_000L
    | 3 -> Some 1_000L
    | 4 -> Some 100L
    | 5 -> Some 10L
    | 6 -> Some 1L
    | _ -> None
  in

  let* decimal = Int64.of_string_opt decimal in
  Micro.from_int64 @@ Int64.mul p decimal

let from_string x =
  match String.(split_on_char '.' @@ trim x) with
  | [ integral ] | [ integral; "" ] ->
      let open Core_js.Option.Syntax in
      let* integral = Int64.of_string_opt integral in
      from_int64 integral
  | [ integral; decimal ] ->
      let open Core_js.Option.Syntax in
      let* integral = Int64.of_string_opt integral in
      let* integral = from_int64 integral in
      let+ decimal = decimal_from_string decimal in
      Int64.add integral decimal
  | _ -> None

let ( + ) = Int64.add

let ( - ) x y =
  let res = Int64.sub x y in
  if Int64.compare res 0L < 0 then None else Some res

let ( -! ) = Int64.sub
let equal = Int64.equal
let compare = Int64.compare
