type ('a, 'b) t = { value : string; repr : ('a, 'b) result option }

let empty () = { value = ""; repr = None }
let is_asked { repr; _ } = Option.is_some repr

let error { repr; _ } =
  match repr with Some (Error err) -> Some err | _ -> None

let has_error inputable = inputable |> error |> Option.is_some
let get_result { repr; _ } = match repr with Some (Ok x) -> Some x | _ -> None
let get_value { value; _ } = value
let is_valid x = is_asked x && not (has_error x)

let is_valid_and inputable callback =
  match get_result inputable with Some x -> callback x | None -> false

let set_value validation str =
  match String.trim str with
  | "" -> empty ()
  | str -> { value = str; repr = Some (validation str) }

let repr { repr; _ } = repr
let map f x = { x with repr = Option.map (Result.map f) x.repr }

let bind f x =
  {
    x with
    repr =
      (match x.repr with
      | None -> None
      | Some (Error x) -> Some (Error x)
      | Some (Ok x) -> f x)
  }

let map_error f x =
  {
    x with
    repr =
      (match x.repr with
      | None -> None
      | Some (Error x) -> Some (Error (f x))
      | Some (Ok x) -> Some (Ok x))
  }

module Infix = struct
  let ( >|= ) x f = map f x
  let ( >>= ) x f = bind f x
end

module Syntax = struct
  let ( let+ ) x f = map f x
  let ( let* ) x f = bind f x
end

include Infix
include Syntax
