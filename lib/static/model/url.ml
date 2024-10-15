open Model_util

type scheme =
  | Http
  | Https
  | Gemini
  | Other of string

type t =
  | External of scheme * string
  | Internal of Yocaml.Path.t

let http s = External (Http, s)
let https s = External (Https, s)
let gemini s = External (Gemini, s)
let from_path p = Internal p

let scheme_to_string = function
  | Http -> "http"
  | Https -> "https"
  | Gemini -> "gemini"
  | Other p -> p
;;

let scheme_to_prefix s = scheme_to_string s ^ "://"

let scheme_from_string = function
  | "http" -> Http
  | "https" -> Https
  | "gemini" -> Gemini
  | s -> Other s
;;

let invalid_url given = Yocaml.Data.Validation.fail_with ~given "Invalid URL"

let unsupported_scheme given =
  Yocaml.Data.Validation.fail_with ~given "Invalid Scheme"
;;

let is_slash x = Char.equal '/' x
let are_slashes a b = is_slash a && is_slash b

let extract_scheme given =
  let len = String.length given in
  let rec aux i acc =
    if i >= len
    then None
    else (
      let curr = given.[i] in
      match curr with
      | ':' ->
        if i < len - 3 && are_slashes given.[i + 1] given.[i + 2]
        then (
          let acc = String.lowercase_ascii acc in
          let rest = String.sub given (i + 3) (len - i - 3) in
          Some (scheme_from_string acc, rest))
        else None
      | '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' | '.' ->
        aux (succ i) (acc ^ String.make 1 curr)
      | _ -> None
      | exception Invalid_argument _ -> None)
  in
  aux 0 ""
;;

let validate_internal_path given =
  match String.split_on_char '/' given with
  | [] | [ "" ] -> invalid_url given
  | "" :: rest -> Ok (Internal (Yocaml.Path.abs rest))
  | xs -> Ok (Internal (Yocaml.Path.rel xs))
;;

let from_string given =
  let given = String.trim given in
  match extract_scheme given with
  | Some (Other _, _) -> unsupported_scheme given
  | Some (scheme, rest) -> Ok (External (scheme, rest))
  | None -> validate_internal_path given
;;

let validate =
  let open Yocaml.Data.Validation in
  string & from_string
;;

let equal_scheme a b =
  match a, b with
  | Http, Http -> true
  | Https, Https -> true
  | Gemini, Gemini -> true
  | Other a, Other b -> String.equal a b
  | Http, _ | Https, _ | Gemini, _ | Other _, _ -> false
;;

let equal a b =
  match a, b with
  | Internal a, Internal b -> Yocaml.Path.equal a b
  | External (scheme_a, a), External (scheme_b, b) ->
    equal_scheme scheme_a scheme_b && String.equal a b
  | Internal _, External _ | External _, Internal _ -> false
;;

let kind_of = function
  | External _ -> "external"
  | Internal _ -> "internal"
;;

let scheme_of = function
  | External (scheme, _) -> Some scheme
  | Internal _ -> None
;;

let make_urls = function
  | External (s, suffix) -> scheme_to_prefix s ^ suffix, suffix
  | Internal p ->
    let p = Yocaml.Path.to_string p in
    p, p
;;

let normalize url =
  let open Yocaml.Data in
  let scheme = Option.map scheme_to_string @@ scheme_of url in
  let has_scheme = exists_from_opt scheme in
  let url_1, url_2 = make_urls url in
  record
    [ "kind", string @@ kind_of url
    ; "has_scheme", has_scheme
    ; "scheme", option string scheme
    ; "url", string url_1
    ; "url_without_scheme", string url_2
    ]
;;

let get_url ?(with_scheme = false) = function
  | Internal p -> Yocaml.Path.to_string p
  | External (s, suf) -> if with_scheme then scheme_to_prefix s ^ suf else suf
;;

let resolve source target =
  match source, target with
  | External (scheme, path), Internal target ->
    External (scheme, Filename.concat path (Yocaml.Path.to_string target))
  | _ -> target (* do not resolve target if target are not resolvable. *)
;;

let extension = function
  | Internal path -> Yocaml.Path.extension path
  | External (_, k) -> Filename.extension k
;;
