class t :
  document_kind:Model.Types.document_kind
  -> title:string
  -> charset:string option
  -> cover:Model.Cover.t option
  -> description:string option
  -> synopsis:string option
  -> section:string option
  -> published_at:Yocaml.Datetime.t option
  -> updated_at:Yocaml.Datetime.t option
  -> tags:string list
  -> breadcrumb:Model.Link.t list
  -> indexes:Model.Indexes.t
  -> display_toc:bool
  -> notes:Model.Temporal_note.t
  -> Types.common

val validate
  :  (string * Yocaml.Data.t) list
  -> t Yocaml.Data.Validation.validated_record

val normalize : #t -> (string * Yocaml.Data.t) list
val meta : #t -> Model.Meta.t option list
