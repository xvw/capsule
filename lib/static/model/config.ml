type t =
  { title : string
  ; repository : Repo.t
  ; branch : string
  ; software_license : Link.t
  ; content_license : Link.t
  }

let entity_name = "Configuration"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun bag ->
    let+ title = required bag "title" string
    and+ repository = required bag "repository" Repo.validate
    and+ branch = optional_or ~default:"main" bag "branch" string
    and+ software_license = required bag "software_license" Link.validate
    and+ content_license = required bag "content_license" Link.validate in
    { title; repository; branch; software_license; content_license })
;;

let normalize { title; repository; branch; software_license; content_license } =
  let open Yocaml.Data in
  record
    [ "main_title", string title
    ; "repository", Repo.normalize repository
    ; "branch", string branch
    ; "software_license", Link.normalize software_license
    ; "content_license", Link.normalize content_license
    ]
;;

let repository_of { repository; _ } = repository
let branch_of { branch; _ } = branch
