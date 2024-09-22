type t =
  { title : string
  ; repository : Repo.t
  ; branch : string
  }

let entity_name = "Configuration"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun bag ->
    let+ title = required bag "title" string
    and+ repository = required bag "repository" Repo.validate
    and+ branch = optional_or ~default:"main" bag "branch" string in
    { title; repository; branch })
;;

let normalize { title; repository; branch } =
  let open Yocaml.Data in
  record
    [ "main-title", string title
    ; "repository", Repo.normalize repository
    ; "branch", string branch
    ]
;;

let repository_of { repository; _ } = repository
let branch_of { branch; _ } = branch
