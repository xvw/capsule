class type ['config] with_configuration = object
  method configuration : 'config
end

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
  method synopsis : string
  method breadcrumb : Link.t list
  method tags : string list
  method display_toc : bool
  method toc : string option
  method with_toc : string option -> 'a
  method on_description : (string option -> string option) -> 'a
  method on_synopsis : (string -> string) -> 'a
end

module type NORMALIZABLE = sig
  type t

  val normalize : t -> Yocaml.Data.t
end

module type VALIDABLE = sig
  type t

  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
end

module type MODEL = sig
  include NORMALIZABLE
  include VALIDABLE with type t := t
end

module type KEY_VALUE = sig
  type t
  type key
  type value

  val from_list : (key * value) list -> t
  val to_list : t -> (key * value) list
  val empty : t
  val has_elements : t -> Yocaml.Data.t

  include MODEL with type t := t
end
