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
  -> ( (Kohai_model.Log.t list * Yocaml.Deps.t) * (Input.t * 'b)
       , (t * 'b) * Yocaml.Deps.t )
       Yocaml.Task.t
