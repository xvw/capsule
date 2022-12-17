(** A complete interface for [Option.t]. *)

include Interfaces.OPTIONAL with type 'a t = 'a option
