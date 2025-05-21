module Input : sig
  type t

  include Yocaml.Required.DATA_READABLE with type t := t
end

type t

include Yocaml.Required.DATA_INJECTABLE with type t := t

val configure_from_logs
  :  config:Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> kind:Model.Types.document_kind
  -> on_synopsis:(string -> string)
  -> ( (Kohai_model.Log.t list * Yocaml.Deps.t) * (Input.t * 'b)
       , (t * 'b) * Yocaml.Deps.t )
       Yocaml.Task.t

val configure_from_states
  :  config:Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> kind:Model.Types.document_kind
  -> on_synopsis:(string -> string)
  -> ( ((string * Kohai_model.State.t) list
       * (string * Kohai_model.State.t) list
       * 'a)
       * (Input.t * 'b)
       , (t * 'b) * 'a )
       Yocaml.Task.t
