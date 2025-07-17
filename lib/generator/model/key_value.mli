module Make (K : Types.COMPARABLE_MODEL) (V : Types.MODEL) :
  Types.KEY_VALUE with type key = K.t and type value = V.t

module By_string (V : Types.MODEL) :
  Types.KEY_VALUE with type key = string and type value = V.t

module String : Types.KEY_VALUE with type key = string and type value = string
module Links : Types.KEY_VALUE with type key = string and type value = Link.t
