type t = Z.t

let zMillion = Z.of_int64 1_000_000L
let to_z amount = amount
let of_mutez amount = amount
let of_tez amount = Z.mul zMillion amount
let of_int_in_tez x = x |> Z.of_int |> of_tez
let of_int64_in_tez x = x |> Z.of_int64 |> of_tez
let to_tez_z amount = Z.div amount zMillion
let of_nanotez amount = Z.div (Z.of_int 1000) amount |> of_mutez
let zero = Z.zero

let pp ppf tez =
  let left = Z.div tez zMillion and right = Z.rem tez zMillion in
  Format.fprintf ppf "%a.%06Li" Z.pp_print left (Z.to_int64 right)

let to_string tez = Format.asprintf "%a" pp tez

let encoding =
  let open Data_encoding in
  conv to_z of_mutez z

let max x y = Z.max x y
let plus = Z.add
let ( + ) = plus
let of_int x = x |> Z.of_int |> of_mutez
let of_int64 x = x |> Z.of_int64 |> of_mutez

let of_string_in_tez x =
  match String.(split_on_char '.' @@ trim x) with
  | [ integral ] | [ integral; "" ] ->
      let open Core_js.Option.Syntax in
      let* integral = try Some (Z.of_string integral) with _ -> None in
      let result = of_tez integral in
      if result < Z.zero then None else Some result
  | [ integral; decimal ] ->
      let open Core_js.Option.Syntax in
      let* integral = try Some (Z.of_string integral) with _ -> None in
      let* decimal = try Some (Z.of_string decimal) with _ -> None in
      let dec_part = of_mutez decimal in
      let int_part = of_tez integral in
      let result = int_part + dec_part in
      if result < Z.zero then None else Some result
  | _ -> None
