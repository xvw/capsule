type t = (Yocaml.Datetime.t * string) list

let validate =
  let open Yocaml.Data.Validation in
  list_of
    (record (fun fields ->
       let+ date = required fields "when" Yocaml.Datetime.validate
       and+ message = required fields "message" string in
       date, message))
  $ List.sort (fun (a, _) (b, _) -> Yocaml.Datetime.compare b a)
;;

let normalize =
  let open Yocaml.Data in
  list_of (fun (date, message) ->
    record [ "when", Yocaml.Datetime.normalize date; "message", string message ])
;;

let on_messages f = List.map (fun (a, s) -> a, f s)
