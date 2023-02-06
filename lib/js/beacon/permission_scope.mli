type t = ENCRYPT | OPERATION_REQUEST | SIGN | THRESHOLD

val to_string : t -> string
val from_string : string -> t option
val from_js_array : Bindings.permission_scopes -> t list
val to_js_array : t list -> Bindings.permission_scopes
