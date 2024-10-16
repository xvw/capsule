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
  method page_title : string option
  method page_charset : string option
  method cover : Model.Cover.t option
  method description : string option
  method published_at : Yocaml.Archetype.Datetime.t option
  method updated_at : Yocaml.Archetype.Datetime.t option
  method synopsis : string
  method section : string option
  method breadcrumb : Model.Link.t list
  method tags : string list
  method display_toc : bool
  method toc : string option
  method with_toc : string option -> 'a
  method on_description : (string option -> string option) -> 'a
  method on_synopsis : (string -> string) -> 'a
end
