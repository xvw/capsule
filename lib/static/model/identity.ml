open Model_util

type t =
  { display_name : string
  ; avatar : Url.t option
  ; website : Link.t option
  ; x_account : string option
  ; mastodon_account : (Url.t * string) option
  ; github_account : string option
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
  record (fun fields ->
    let+ display_name =
      required
        fields
        "display_name"
        (string & minimal_length ~length:String.length 2)
    and+ avatar = optional fields "avatar" Url.validate
    and+ website = optional fields "website" Link.validate
    and+ x_account = optional fields "x_account" string
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
    ; website
    ; custom_attributes
    ; more_links
    ; x_account
    ; mastodon_account
    ; github_account
    ; more_accounts
    ; avatar
    })
;;

let normalize
  { display_name
  ; avatar
  ; website
  ; custom_attributes
  ; more_links
  ; x_account
  ; mastodon_account
  ; github_account
  ; more_accounts
  }
  =
  let open Yocaml.Data in
  let m_instance = Option.map fst mastodon_account
  and m_account = Option.map snd mastodon_account in
  record
    [ "display_name", string display_name
    ; "avatar", option Url.normalize avatar
    ; "website", option Link.normalize website
    ; "x_account", option string x_account
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
    ; "has_mastodon_account", exists_from_opt mastodon_account
    ]
;;
