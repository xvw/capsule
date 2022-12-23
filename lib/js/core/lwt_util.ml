let return = Lwt.return
let return_ok x = return @@ Ok x
let return_error x = return @@ Error x
let map = Lwt.map
let bind f x = Lwt.bind x f

let map_ok f promise =
  bind
    (function Ok x -> return_ok (f x) | Error err -> return_error err)
    promise

let bind_ok f promise =
  bind (function Ok x -> f x | Error err -> return_error err) promise

let map_error f promise =
  bind
    (function Ok x -> return_ok x | Error err -> return_error (f err))
    promise

module Infix = struct
  let ( >|= ) x f = map f x
  let ( >>= ) x f = bind f x
  let ( >|=? ) promise f = map_ok f promise
  let ( >|=! ) promise f = map_error f promise
  let ( >>=? ) promise f = bind_ok f promise
end

include Infix

module Syntax = struct
  let ( let+ ) x f = map f x
  let ( let* ) x f = bind f x
  let ( let+? ) x f = map_ok f x
  let ( let+! ) x f = map_error f x
  let ( let*? ) x f = bind_ok f x
end

include Syntax
