(** A complete interface for [Js.optdef]. *)

include Interfaces.OPTIONAL with type 'a t = 'a Js_of_ocaml.Js.optdef
