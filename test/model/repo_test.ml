open Generator.Model

let%expect_test "validate a simple repo - 1" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "github/xvw/capsule" in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {|
    {"kind": "github", "homepage":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://github.com/xvw/capsule", "url_without_scheme":
      "github.com/xvw/capsule"},
    "bug-report":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://github.com/xvw/capsule/issues", "url_without_scheme":
      "github.com/xvw/capsule/issues"},
    "ssh": "git@github.com:xvw/capsule.git"}
    |}]
;;

let%expect_test "validate a simple repo (with trailing slash) - 2" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "github/xvw/capsule/" in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {|
    {"kind": "github", "homepage":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://github.com/xvw/capsule", "url_without_scheme":
      "github.com/xvw/capsule"},
    "bug-report":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://github.com/xvw/capsule/issues", "url_without_scheme":
      "github.com/xvw/capsule/issues"},
    "ssh": "git@github.com:xvw/capsule.git"}
    |}]
;;

let%expect_test "validate a simple repo - 3" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "gitlab/funkywork/yocaml" in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {|
    {"kind": "gitlab", "homepage":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://gitlab.com/funkywork/yocaml", "url_without_scheme":
      "gitlab.com/funkywork/yocaml"},
    "bug-report":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://gitlab.com/funkywork/yocaml/-/issues", "url_without_scheme":
      "gitlab.com/funkywork/yocaml/-/issues"},
    "ssh": "git@gitlab.com:funkywork/yocaml.git"}
    |}]
;;

let%expect_test "validate a simple repo - 4" =
  let open Yocaml.Data in
  let repo =
    Repo.validate @@ string "gitlab/framasoft/peertube/documentation"
  in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {|
    {"kind": "gitlab", "homepage":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://gitlab.com/framasoft/peertube/documentation",
     "url_without_scheme": "gitlab.com/framasoft/peertube/documentation"},
    "bug-report":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://gitlab.com/framasoft/peertube/documentation/-/issues",
     "url_without_scheme":
      "gitlab.com/framasoft/peertube/documentation/-/issues"},
    "ssh": "git@gitlab.com:framasoft/peertube/documentation.git"}
    |}]
;;

let%expect_test "validate an invalid repo - 1" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "gitab/funkywork/yocaml" in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {| <error-with-message: invalid kind gitab> for `gitab/funkywork/yocaml` |}]
;;

let%expect_test "validate an invalid repo - 2" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "gitlab/framasoft/yocaml/foo/bar" in
  Util.print_normalized_value Repo.normalize repo;
  [%expect
    {| <error-with-message: invalid repository> for `gitlab/framasoft/yocaml/foo/bar` |}]
;;

let%expect_test "resolve file from a github repository - 1" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "github/xvw/capsule" in
  let url =
    Result.map (Repo.resolve_path @@ Yocaml.Path.rel [ "LICENSE" ]) repo
  in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "https://github.com/xvw/capsule/blob/main/LICENSE", "url_without_scheme":
     "github.com/xvw/capsule/blob/main/LICENSE"}
    |}]
;;

let%expect_test "resolve file from a github repository - 2" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "github/xvw/capsule" in
  let url =
    Result.map
      (Repo.resolve_path
       @@ Yocaml.Path.rel [ "content"; "dapps"; "transfer"; "manifest.md" ])
      repo
  in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "https://github.com/xvw/capsule/blob/main/content/dapps/transfer/manifest.md",
    "url_without_scheme":
     "github.com/xvw/capsule/blob/main/content/dapps/transfer/manifest.md"}
    |}]
;;

let%expect_test "resolve file from a gitlab repository - 1" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "gitlab/funkywork/yocaml" in
  let url =
    Result.map (Repo.resolve_path @@ Yocaml.Path.rel [ "LICENSE" ]) repo
  in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "https://gitlab.com/funkywork/yocaml/-/blob/main/LICENSE",
    "url_without_scheme": "gitlab.com/funkywork/yocaml/-/blob/main/LICENSE"}
    |}]
;;

let%expect_test "resolve file from a gitlab repository - 2" =
  let open Yocaml.Data in
  let repo = Repo.validate @@ string "gitlab/funkywork/yocaml" in
  let url =
    Result.map
      (Repo.resolve_path
       @@ Yocaml.Path.rel [ "examples"; "simple-blog-git"; "pages"; "links.md" ]
      )
      repo
  in
  Util.print_normalized_value Url.normalize url;
  [%expect
    {|
    {"kind": "external", "has_scheme": true, "scheme": "https", "url":
     "https://gitlab.com/funkywork/yocaml/-/blob/main/examples/simple-blog-git/pages/links.md",
    "url_without_scheme":
     "gitlab.com/funkywork/yocaml/-/blob/main/examples/simple-blog-git/pages/links.md"}
    |}]
;;
