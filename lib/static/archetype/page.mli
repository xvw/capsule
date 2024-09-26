type t

include Yocaml.Required.DATA_INJECTABLE with type t := t

module Parse : sig
  type t

  include Yocaml.Required.DATA_READABLE with type t := t
end

val configure
  :  Model.Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> (Parse.t * 'a, t * 'a) Yocaml.Task.t

val table_of_contents : t -> string option -> t
