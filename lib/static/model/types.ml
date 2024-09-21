class type with_target_path = object
  method target_path : Yocaml.Path.t
end

class type with_source_path = object
  method source_path : Yocaml.Path.t
end

class type common = object ('a)
  method page_title : string option
  method page_charset : string option
  method description : string option
  method tags : string list
  method display_toc : bool
  method toc : string option
  method with_toc : string option -> 'a
  method on_description : (string option -> string option) -> 'a
end
