type t

include Yocaml.Required.DATA_INJECTABLE with type t := t

module Parse : sig
  type t

  include Yocaml.Required.DATA_READABLE with type t := t

  val page_title : t -> string
  val page_datetime : t -> Yocaml.Datetime.t
  val page_tags : t -> string list
  val page_summary : t -> string
end

val configure
  :  Config.t
  -> source:Yocaml.Path.t
  -> target:Yocaml.Path.t
  -> (Parse.t * 'a, t * 'a) Yocaml.Task.t

val table_of_contents : t -> string option -> t
val on_synopsis : (string -> string) -> (t * 'a, t * 'a) Yocaml.Task.t
val as_index : unit -> (t * 'a, t * 'a) Yocaml.Task.t
val as_article : unit -> (t * 'a, t * 'a) Yocaml.Task.t

val define_document_kind
  :  Model.Types.document_kind
  -> (t * 'a, t * 'a) Yocaml.Task.t
