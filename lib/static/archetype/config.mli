type t

include Yocaml.Required.DATA_READABLE with type t := t

val repository_of : t -> Model.Repo.t
val branch_of : t -> string
val owner_of : t -> Model.Identity.t

include Model.Types.NORMALIZABLE with type t := t
