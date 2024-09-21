open Static.Model

let%expect_test "validate a simple internal url - 1" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "/foo/bar/baz" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "internal", "has_scheme": false, "scheme": null, "url":
     "/foo/bar/baz", "url_without_scheme": "/foo/bar/baz"}
    |}]
;;

let%expect_test "validate a simple internal url - 2" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "foo/bar/baz" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "internal", "has_scheme": false, "scheme": null, "url":
     "./foo/bar/baz", "url_without_scheme": "./foo/bar/baz"}
    |}]
;;

let%expect_test "validate an invalid url - 1" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "" in
  Util.print_normalized_value Url.normalize url;
  [%expect {| <error-with-message: Invalid URL> for `` |}]
;;

let%expect_test "validate a simple external url - 1" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "http://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "http", "url":
     "http://gnu.org", "url_without_scheme": "gnu.org"}
    |}]
;;

let%expect_test "validate a simple external url - 2" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "https://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "https://gnu.org", "url_without_scheme": "gnu.org"}
    |}]
;;

let%expect_test "validate a simple external url - 3" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "gemini://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "gemini", "url":
     "gemini://gnu.org", "url_without_scheme": "gnu.org"}
    |}]
;;

let%expect_test "validate a simple external url with invalidate protocol - 1" =
  let open Yocaml.Data in
  let url = Url.validate @@ string "ftp://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect {| <error-with-message: Invalid Scheme> for `ftp://gnu.org` |}]
;;
