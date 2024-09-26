(** Currently only support Github and Gitlab (because it is for my own
    usage) *)

type t

(** [validate data] validate a string as a repository using the form
    [github_or_gitlab/user/repo]. *)
val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value

val normalize : t -> Yocaml.Data.t
val equal : t -> t -> bool
val resolve_path : ?branch:string -> Yocaml.Path.t -> t -> Url.t
