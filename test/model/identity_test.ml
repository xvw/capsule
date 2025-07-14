open Generator.Model

let%expect_test "validate an invalid identity" =
  let open Yocaml.Data in
  let kv = Identity.validate @@ record [] in
  Util.print_normalized_value Identity.normalize kv;
  [%expect {| <error-invalid-record missing field: display_name> for `{}` |}]
;;

let%expect_test "validate an invalid identity 2" =
  let open Yocaml.Data in
  let kv = Identity.validate @@ record [ "iname", string "foo" ] in
  Util.print_normalized_value Identity.normalize kv;
  [%expect
    {| <error-invalid-record missing field: display_name> for `{"iname": "foo"}` |}]
;;

let%expect_test "validate a simple identity" =
  let open Yocaml.Data in
  let kv = Identity.validate @@ record [ "display_name", string "foo" ] in
  Util.print_normalized_value Identity.normalize kv;
  [%expect
    {|
    {"display_name": "foo", "first_name": null, "last_name": null, "avatar":
     null, "website": null, "x_account": null, "bluesky_account": null,
    "mastodon_instance": null, "mastodon_account": null, "github_account": null,
    "accounts": [], "more_accounts": [], "custom_attributes": [], "more_links":
     [], "has_website": false, "has_attributes": false, "has_links": false,
    "has_more_accounts": false, "has_github_account": false, "has_x_account":
     false, "has_bluesky_account": false, "has_mastodon_account": false,
    "has_first_name": false, "has_last_name": false}
    |}]
;;

let%expect_test "validate a simple identity with name inference" =
  let open Yocaml.Data in
  let kv =
    Identity.validate
    @@ record [ "last_name", string "Vdw"; "first_name", string "Xavier" ]
  in
  Util.print_normalized_value Identity.normalize kv;
  [%expect
    {|
    {"display_name": "X. Vdw", "first_name": "Xavier", "last_name": "Vdw",
    "avatar": null, "website": null, "x_account": null, "bluesky_account": null,
    "mastodon_instance": null, "mastodon_account": null, "github_account": null,
    "accounts": [], "more_accounts": [], "custom_attributes": [], "more_links":
     [], "has_website": false, "has_attributes": false, "has_links": false,
    "has_more_accounts": false, "has_github_account": false, "has_x_account":
     false, "has_bluesky_account": false, "has_mastodon_account": false,
    "has_first_name": true, "has_last_name": true}
    |}]
;;
