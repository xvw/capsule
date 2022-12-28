open Core_js

type t = string

type error =
  [ `Address_invalid_prefix of string
  | `Address_invalid_checksum of string
  | `Address_invalid_length of string ]

let to_string x = x
let from_string x = x

let pp ppf address =
  let len = String.length address in
  let offset = len - 4 in
  let first = String.sub address 0 8 and last = String.sub address offset 4 in
  Format.fprintf ppf "%s..%s" first last

let to_short_string = Format.asprintf "%a" pp

let prefixes =
  [
    ("tz1", "\006\161\159")
  ; ("tz2", "\006\161\161")
  ; ("tz3", "\006\161\164")
  ; ("tz4", "\006\161\166")
  ; ("KT", "\002\090\121")
  ; ("txr1", "\001\128\120\031")
  ]

let validate address =
  let open Result in
  let alen = String.length address in
  let* prefix =
    List.find_map
      (fun (prefix, prefix_value) ->
        let plen = String.length prefix in
        if plen >= alen then None
        else
          let pref = String.sub address 0 plen in
          if String.equal pref prefix then Some prefix_value else None)
      prefixes
    |> Option.fold (fun _ -> error @@ `Address_invalid_prefix address) ok
  in
  let encoded = Tezos_base58.Base58 address in
  let* decoded =
    Tezos_base58.decode ~prefix encoded
    |> Option.fold (fun _ -> error @@ `Address_invalid_checksum address) ok
  in
  if Int.equal (String.length decoded) 20 then ok address
  else error @@ `Address_invalid_length address

let is_valid x = match validate x with Ok _ -> true | Error _ -> false
