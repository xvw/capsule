open Js_of_ocaml

class type input =
  object
    method containerId : Js.js_string Js.t Js.readonly_prop
  end

val entrypoint : < mount : input Js.t -> unit Lwt.t Js.meth > Js.t
