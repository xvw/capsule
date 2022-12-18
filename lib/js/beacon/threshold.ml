open Js_of_ocaml

type t = { amount : string; timeframe : string }

let from_js threshold =
  let amount = Js.to_string threshold##.amount
  and timeframe = Js.to_string threshold##.timeframe in
  { amount; timeframe }
