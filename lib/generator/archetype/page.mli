type t

include Yocaml.Required.DATA_INJECTABLE with type t := t

module Parse : sig
  type t

  include Yocaml.Required.DATA_READABLE with type t := t
end

val configure
  :  Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> (Parse.t * 'a, t * 'a) Yocaml.Task.t

val table_of_contents : t -> string option -> t
val on_synopsis : (string -> string) -> (t * 'a, t * 'a) Yocaml.Task.t
val as_index : unit -> (t * 'a, t * 'a) Yocaml.Task.t
