type t

include Yocaml.Required.DATA_READABLE with type t := t

val repository_of : t -> Repo.t
val branch_of : t -> string
val normalize : t -> Yocaml.Data.t
