type t = Z.t

let zMillion = Z.of_int64 1_000_000L
let to_z amount = amount
let of_mutez amount = amount
let zero = Z.zero

let pp ppf tez =
  let left = Z.div tez zMillion and right = Z.rem tez zMillion in
  Format.fprintf ppf "%a.%a" Z.pp_print left Z.pp_print right

let to_string tez = Format.asprintf "%a" pp tez

let encoding =
  let open Data_encoding in
  conv to_z of_mutez z
