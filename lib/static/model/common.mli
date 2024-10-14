class t :
  title:string option
  -> charset:string option
  -> description:string option
  -> synopsis:string
  -> published_at:Yocaml.Archetype.Datetime.t option
  -> updated_at:Yocaml.Archetype.Datetime.t option
  -> tags:string list
  -> breadcrumb:Link.t list
  -> display_toc:bool
  -> Types.common

val validate
  :  (string * Yocaml.Data.t) list
  -> t Yocaml.Data.Validation.validated_record

val normalize : #t -> (string * Yocaml.Data.t) list
val meta : #t -> Meta.t option list
