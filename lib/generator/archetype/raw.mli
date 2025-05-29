module Input : sig
  class type t = Types.common

  val make
    :  ?title:string
    -> ?document_kind:Model.Types.document_kind
    -> ?charset:string
    -> ?cover:Model.Cover.t
    -> ?description:string
    -> ?synopsis:string
    -> ?section:string
    -> ?published_at:Yocaml.Datetime.t
    -> ?updated_at:Yocaml.Datetime.t
    -> ?tags:string list
    -> ?breadcrumb:Model.Link.t list
    -> ?indexes:Model.Indexes.t
    -> ?display_toc:bool
    -> ?notes:Model.Temporal_note.t
    -> unit
    -> Common.t

  val default_project_breadcrumb : Model.Link.t list

  val empty_project
    :  ?with_notice:bool
    -> ?synopsis:string
    -> ?title:string
    -> unit
    -> t

  val to_entry : file:Yocaml.Path.t -> url:Yocaml.Path.t -> t -> Model.Entry.t
  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
end

module Output : sig
  type t

  val configure
    :  config:Config.t
    -> source:Yocaml.Path.t
    -> target:Yocaml.Path.t
    -> Input.t
    -> t

  val full_configure
    :  ?updated_at:Yocaml.Datetime.t
    -> ?published_at:Yocaml.Datetime.t
    -> config:Config.t
    -> source:Yocaml.Path.t
    -> target:Yocaml.Path.t
    -> kind:Model.Types.document_kind
    -> on_synopsis:(string -> string)
    -> Input.t
    -> t

  val on_synopsis : (string -> string) -> t -> t
  val define_document_kind : Model.Types.document_kind -> t -> t
  val table_of_content : t -> string option -> t
  val normalize : t -> (string * Yocaml.Data.t) list
end
