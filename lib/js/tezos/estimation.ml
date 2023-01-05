(* open Core_js *)

type t = Transfer of { source : Address.t; target : Address.t }

(* let estimate ~cost_per_byte = function *)
(*   | Transfer { source; target } -> *)
(*       let open Result.Syntax in *)
(*       let* source = Address.validate source in *)
(*       let+ target = Address.validate target in *)
(*       (source, target) *)
