class t :
  document_kind:Model.Types.document_kind
  -> title:string option
  -> charset:string option
  -> cover:Model.Cover.t option
  -> description:string option
  -> synopsis:string
  -> section:string option
  -> published_at:Yocaml.Archetype.Datetime.t option
  -> updated_at:Yocaml.Archetype.Datetime.t option
  -> tags:string list
  -> breadcrumb:Model.Link.t list
  -> indexes:Model.Indexes.t
  -> display_toc:bool
  -> Types.common

val validate
  :  (string * Yocaml.Data.t) list
  -> t Yocaml.Data.Validation.validated_record

val normalize : #t -> (string * Yocaml.Data.t) list
val meta : #t -> Model.Meta.t option list
