class type with_configuration = object
  method configuration : Config.t
end

class type with_target_path = object
  method target_path : Yocaml.Path.t
end

class type with_source_path = object
  method source_path : Yocaml.Path.t
end

class type common = object ('a)
  method document_kind : Model.Types.document_kind
  method page_title : string
  method page_charset : string option
  method cover : Model.Cover.t option
  method description : string option
  method published_at : Yocaml.Archetype.Datetime.t option
  method updated_at : Yocaml.Archetype.Datetime.t option
  method synopsis : string
  method section : string option
  method breadcrumb : Model.Link.t list
  method indexes : Model.Indexes.t
  method tags : string list
  method display_toc : bool
  method toc : string option
  method with_toc : string option -> 'a
  method on_description : (string option -> string option) -> 'a
  method on_synopsis : (string -> string) -> 'a
  method on_index : (Model.Index.t -> Model.Index.t) -> 'a

  method on_document_kind :
    (Model.Types.document_kind -> Model.Types.document_kind) -> 'a
end

module type ARCHETYPE = sig
  module Input : sig
    type t

    include Yocaml.Required.DATA_READABLE with type t := t

    val to_entry : file:Yocaml.Path.t -> url:Yocaml.Path.t -> t -> Model.Entry.t
  end

  type t

  val full_configure
    :  config:Config.t
    -> source:Yocaml.Path.t
    -> target:Yocaml.Path.t
    -> kind:Model.Types.document_kind
    -> on_synopsis:(string -> string)
    -> (Input.t * 'a, t * 'a) Yocaml.Task.t

  val table_of_content : t -> string option -> t

  include Yocaml.Required.DATA_INJECTABLE with type t := t
end
