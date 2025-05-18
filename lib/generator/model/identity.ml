open Model_util

type t =
  { display_name : string
  ; first_name : string option
  ; last_name : string option
  ; avatar : Url.t option
  ; website : Link.t option
  ; x_account : string option
  ; mastodon_account : (Url.t * string) option
  ; github_account : string option
  ; bluesky_account : string option
  ; more_accounts : Link.t list
  ; custom_attributes : Key_value.String.t
  ; more_links : Link.t list
  }

let mastodon =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ instance = required fields "instance" Url.validate
    and+ username =
      required
        fields
        "username"
        (string & minimal_length ~length:String.length 2)
    in
    instance, username)
;;

let validate =
  let open Yocaml.Data.Validation in
  let s = string & minimal_length ~length:String.length 2 in
  record (fun fields ->
    let+ display_name = required fields "display_name" s
    and+ first_name = optional fields "first_name" s
    and+ last_name = optional fields "last_name" s
    and+ avatar = optional fields "avatar" Url.validate
    and+ website = optional fields "website" Link.validate
    and+ x_account = optional fields "x_account" string
    and+ bluesky_account = optional fields "bluesky_account" string
    and+ mastodon_account = optional fields "mastodon_account" mastodon
    and+ github_account = optional fields "github_account" string
    and+ custom_attributes =
      optional_or
        fields
        ~default:Key_value.String.empty
        "custom_attributes"
        Key_value.String.validate
    and+ more_links =
      optional_or fields ~default:[] "more_links" (list_of Link.validate)
    and+ more_accounts =
      optional_or fields ~default:[] "more_accounts" (list_of Link.validate)
    in
    { display_name
    ; first_name
    ; last_name
    ; website
    ; custom_attributes
    ; more_links
    ; x_account
    ; bluesky_account
    ; mastodon_account
    ; github_account
    ; more_accounts
    ; avatar
    })
;;

let normalize
      { display_name
      ; first_name
      ; last_name
      ; avatar
      ; website
      ; custom_attributes
      ; more_links
      ; x_account
      ; mastodon_account
      ; bluesky_account
      ; github_account
      ; more_accounts
      }
  =
  let open Yocaml.Data in
  let m_instance = Option.map fst mastodon_account
  and m_account = Option.map snd mastodon_account in
  record
    [ "display_name", string display_name
    ; "first_name", option string first_name
    ; "last_name", option string last_name
    ; "avatar", option Url.normalize avatar
    ; "website", option Link.normalize website
    ; "x_account", option string x_account
    ; "bluesky_account", option string bluesky_account
    ; "mastodon_instance", option Url.normalize m_instance
    ; "mastodon_account", option string m_account
    ; "github_account", option string github_account
    ; "accounts", list_of Link.normalize more_accounts
    ; "more_accounts", list_of Link.normalize more_accounts
    ; "custom_attributes", Key_value.String.normalize custom_attributes
    ; "more_links", list_of Link.normalize more_links
    ; "has_website", exists_from_opt website
    ; "has_attributes", Key_value.String.has_elements custom_attributes
    ; "has_links", exists_from_list more_links
    ; "has_more_accounts", exists_from_list more_accounts
    ; "has_github_account", exists_from_opt github_account
    ; "has_x_account", exists_from_opt x_account
    ; "has_bluesky_account", exists_from_opt bluesky_account
    ; "has_mastodon_account", exists_from_opt mastodon_account
    ; "has_first_name", exists_from_opt first_name
    ; "has_last_name", exists_from_opt last_name
    ]
;;

let twitter_meta_for { x_account; _ } =
  match x_account with
  | None -> []
  | Some x ->
    let handle = Some ("@" ^ x) in
    [ Meta.from_option "twitter:site" handle
    ; Meta.from_option "twitter:creator" handle
    ]
;;

let render_name { display_name; last_name; first_name; _ } =
  match first_name, last_name with
  | Some fname, Some lname -> display_name ^ ", " ^ fname ^ " " ^ lname
  | _ -> display_name
;;

let meta_author idt = Meta.from_option "author" (Some (render_name idt))

let to_open_graph { display_name; last_name; first_name; _ } =
  Meta.from_option "og:profile:username" (Some display_name)
  :: [ Meta.from_option "og:profile:first_name" first_name
     ; Meta.from_option "og:profile:last_name" last_name
     ]
;;

let meta_for t = (meta_author t :: twitter_meta_for t) @ to_open_graph t

let to_person p =
  Yocaml_syndication.Person.make
    ?uri:(Option.map (fun link -> link |> Link.url |> Url.to_string) p.website)
    (render_name p)
;;
