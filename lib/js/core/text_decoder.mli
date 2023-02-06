open Js_of_ocaml

type t

val make : ?label:string -> unit -> t
val decode : t -> Typed_array.int8Array Js.t -> string
