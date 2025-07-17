type document_kind =
  | Index
  | Article

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

module type COMPARABLE_MODEL = sig
  include MODEL

  val compare : t -> t -> int
end

module type KEY_VALUE = sig
  type t
  type key
  type value

  val from_list : (key * value) list -> t
  val to_list : t -> (key * value) list
  val empty : t
  val has_elements : t -> Yocaml.Data.t
  val find : t -> key -> value option
  val exists : t -> key -> bool

  include MODEL with type t := t
end
