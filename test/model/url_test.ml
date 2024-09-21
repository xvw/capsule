open Static.Model

let%expect_test "validate a simple internal url - 1" =
  let url = Url.validate "/foo/bar/baz" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "internal", "has_scheme": false, "scheme": null, "url":
     "/foo/bar/baz", "url_without_scheme": "/foo/bar/baz"}
    |}]

let%expect_test "validate a simple internal url - 2" =
  let url = Url.validate "foo/bar/baz" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "internal", "has_scheme": false, "scheme": null, "url":
     "./foo/bar/baz", "url_without_scheme": "./foo/bar/baz"}
    |}]

let%expect_test "validate an invalid url - 1" =
  let url = Url.validate "" in
  Util.print_normalized_value Url.normalize url;
  [%expect {| <error-with-message: Invalid URL> for `` |}]

let%expect_test "validate a simple external url - 1" =
  let url = Url.validate "http://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "http", "url": "gnu.org",
    "url_without_scheme": "http://gnu.org"}
    |}]

let%expect_test "validate a simple external url - 2" =
  let url = Url.validate "https://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "gnu.org", "url_without_scheme": "https://gnu.org"}
    |}]

let%expect_test "validate a simple external url - 3" =
  let url = Url.validate "gemini://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "gemini", "url":
     "gnu.org", "url_without_scheme": "gemini://gnu.org"}
    |}]

let%expect_test "validate a simple external url with invalidate protocol - 1" =
  let url = Url.validate "ftp://gnu.org" in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {| <error-with-message: Invalid Scheme> for `ftp://gnu.org` |}]
