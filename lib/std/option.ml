let return x = Some x
let map f x = Stdlib.Option.map f x
let bind f x = Stdlib.Option.bind x f

let ap f a =
  match f, a with
  | Some f, Some a -> Some (f a)
  | _ -> None
;;

let or_ a b =
  match a, b with
  | Some x, _ | None, Some x -> Some x
  | None, None -> None
;;

let zip a b =
  match a, b with
  | Some a, Some b -> Some (a, b)
  | None, _ | _, None -> None
;;

module Infix = struct
  let ( <$> ) = map
  let ( <*> ) = ap
  let ( >|= ) x f = map f x
  let ( >>= ) x f = bind f x
  let ( ** ) a b = zip a b
  let ( <|> ) a b = or_ a b
  let ( || ) a b = Stdlib.Option.value ~default:b a
end

module Syntax = struct
  let ( let+ ) x f = map f x
  let ( let* ) x f = bind f x
  let ( and+ ) a b = zip a b
end

include Infix
include Syntax
