type ('a, 'b) t = ('a, 'b) result = Ok of 'a | Error of 'b

let return x = Ok x
let ok x = return x
let error x = Error x
let map = Result.map
let bind f x = Result.bind x f
let map_ok = Result.map
let map_error = Result.map_error
let ( >>= ) x f = bind f x
let fold = Result.fold

let product a b =
  a >>= fun x ->
  b >>= fun y -> return (x, y)

module Infix = struct
  let ( >|= ) x f = map f x
  let ( >>= ) = ( >>= )
  let ( >|=! ) x f = map_error f x
end

include Infix

module Syntax = struct
  let ( let+ ) x f = map f x
  let ( let* ) x f = bind f x
  let ( let+! ) x f = map_error f x
  let ( and+ ) a b = product a b
end

include Syntax
