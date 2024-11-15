module Input : sig
  type t

  include Yocaml.Required.DATA_READABLE with type t := t
end

type t

include Yocaml.Required.DATA_INJECTABLE with type t := t

val full_configure
  :  config:Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> kind:Model.Types.document_kind
  -> on_synopsis:(string -> string)
  -> length:int
  -> entries:(Journal_entry.Input.t * string * Yocaml.Path.t) list
  -> index:int
  -> (Input.t * 'a, t * 'a) Yocaml.Task.t

val deps_of
  :  (Journal_entry.Input.t * string * Yocaml.Path.t) list
  -> Yocaml.Path.t list
