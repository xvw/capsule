type t = Z.t

let zMillion = Z.of_int64 1_000_000L
let to_z amount = amount
let of_mutez amount = amount
let of_nanotez amount = Z.div (Z.of_int 1000) amount |> of_mutez
let zero = Z.zero

let pp ppf tez =
  let left = Z.div tez zMillion and right = Z.rem tez zMillion in
  Format.fprintf ppf "%a.%06Li" Z.pp_print left (Z.to_int64 right)

let to_string tez = Format.asprintf "%a" pp tez

let encoding =
  let open Data_encoding in
  conv to_z of_mutez z
