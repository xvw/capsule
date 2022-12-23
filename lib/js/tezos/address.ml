type t = string

let to_string x = x
let from_string x = x

let pp ppf address =
  let len = String.length address in
  let offset = len - 4 in
  let first = String.sub address 0 8 and last = String.sub address offset 4 in
  Format.fprintf ppf "%s..%s" first last
