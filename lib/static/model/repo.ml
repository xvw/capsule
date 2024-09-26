type of_user =
  { user_name : string
  ; repository_name : string
  }

type gitlab =
  | Of_user of of_user
  | Of_organization of
      { organization_name : string
      ; project_name : string
      ; repository_name : string
      }

type t =
  | Github of of_user
  | Gitlab of gitlab

let kind_of = function
  | Github _ -> "github"
  | Gitlab _ -> "gitlab"
;;

let domain_of = function
  | Github _ -> "github.com"
  | Gitlab _ -> "gitlab.com"
;;

let make_suffix = function
  | Github { user_name; repository_name }
  | Gitlab (Of_user { user_name; repository_name }) ->
    user_name ^ "/" ^ repository_name
  | Gitlab
      (Of_organization { organization_name; project_name; repository_name }) ->
    organization_name ^ "/" ^ project_name ^ "/" ^ repository_name
;;

let base_uri_of repo =
  let domain = domain_of repo in
  let suffix = make_suffix repo in
  domain ^ "/" ^ suffix
;;

let homepage repo =
  let uri = base_uri_of repo in
  Url.https uri
;;

let bug_report repo =
  let base_uri = base_uri_of repo in
  let suffix =
    match repo with
    | Github _ -> "issues"
    | Gitlab _ -> "-/issues"
  in
  let uri = base_uri ^ "/" ^ suffix in
  Url.https uri
;;

let ssh repo =
  let domain = domain_of repo in
  let suffix = make_suffix repo in
  "git@" ^ domain ^ ":" ^ suffix ^ ".git"
;;

let normalize repo =
  let open Yocaml.Data in
  record
    [ "kind", string @@ kind_of repo
    ; "homepage", Url.normalize @@ homepage repo
    ; "bug-report", Url.normalize @@ bug_report repo
    ; "ssh", string @@ ssh repo
    ]
;;

let from_string given =
  let open Yocaml.Data.Validation in
  match String.split_on_char '/' given with
  | prov :: user_name :: repository_name :: ([ "" ] | []) ->
    let prov = String.lowercase_ascii prov in
    let usrd = { user_name; repository_name } in
    if String.equal "github" prov
    then Ok (Github usrd)
    else if String.equal "gitlab" prov
    then Ok (Gitlab (Of_user usrd))
    else fail_with ~given ("invalid kind " ^ prov)
  | prov :: organization_name :: project_name :: repository_name :: ([ "" ] | [])
    ->
    let prov = String.lowercase_ascii prov in
    if String.equal "gitlab" prov
    then
      Ok
        (Gitlab
           (Of_organization { organization_name; project_name; repository_name }))
    else fail_with ~given ("invalid kind " ^ prov)
  | _ -> fail_with ~given "invalid repository"
;;

let validate =
  let open Yocaml.Data.Validation in
  string $ String.trim & from_string
;;

let equal_of_user
  { user_name = user_a; repository_name = repo_a }
  { user_name = user_b; repository_name = repo_b }
  =
  String.equal user_a user_b && String.equal repo_a repo_b
;;

let equal a b =
  match a, b with
  | Github a, Github b | Gitlab (Of_user a), Gitlab (Of_user b) ->
    equal_of_user a b
  | ( Gitlab
        (Of_organization
          { organization_name = org_a
          ; project_name = proj_a
          ; repository_name = repo_a
          })
    , Gitlab
        (Of_organization
          { organization_name = org_b
          ; project_name = proj_b
          ; repository_name = repo_b
          }) ) ->
    String.equal org_a org_b
    && String.equal proj_a proj_b
    && String.equal repo_a repo_b
  | Github _, _ | Gitlab _, _ -> false
;;

let resolve_path ?(branch = "main") path repo =
  let base_uri = base_uri_of repo in
  let file = Yocaml.Path.(path |> relocate ~into:root |> to_string) in
  let sep =
    match repo with
    | Github _ -> "/"
    | Gitlab _ -> "/-/"
  in
  let uri = base_uri ^ sep ^ "blob/" ^ branch ^ file in
  Url.https uri
;;
