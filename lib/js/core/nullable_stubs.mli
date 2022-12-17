(** A complete interface for [Js.opt]. *)

include Interfaces.OPTIONAL with type 'a t = 'a Js_of_ocaml.Js.opt
