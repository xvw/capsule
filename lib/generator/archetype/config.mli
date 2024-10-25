type t

include Yocaml.Required.DATA_READABLE with type t := t

val repository_of : t -> Model.Repo.t
val branch_of : t -> string
val owner_of : t -> Model.Identity.t
val main_url_of : t -> Model.Url.t
val default_cover_of : t -> Model.Cover.t option
val resolve_cover : t -> Model.Cover.t option -> Model.Cover.t option

include Model.Types.NORMALIZABLE with type t := t
