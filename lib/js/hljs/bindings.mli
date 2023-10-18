(** A very small binding of Highlight.js *)

open Js_of_ocaml
open Js

class type hljs = object
  method highlightAll : unit meth
end
