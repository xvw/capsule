open Generator.Model

let link title url =
  let open Yocaml.Data in
  record [ "title", string title; "url", string url ]
;;

let full_sort key rev =
  let open Yocaml.Data in
  record [ "key", string key; "rev", bool rev ]
;;

let sort_by_key key =
  let open Yocaml.Data in
  record [ "key", string key ]
;;

let rev r =
  let open Yocaml.Data in
  record [ "rev", bool r ]
;;

let index ?sort () =
  let open Yocaml.Data in
  let list =
    [ "name", string "My index"
    ; "id", string "my-index"
    ; ( "links"
      , list
          [ link "2 - snd link" "https://xvw.github.io"
          ; link "1 - first link" "https://xvw.lol"
          ; link "3 - trd link" "https://github.com"
          ] )
    ]
  in
  let list =
    match sort with
    | None -> list
    | Some x -> ("sort", x) :: list
  in
  record list
;;

let%expect_test "test index without any sort" =
  let index = Index.validate @@ index () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
      "title": "2 - snd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.lol", "url_without_scheme": "xvw.lol"},
     "title": "1 - first link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://github.com", "url_without_scheme": "github.com"},
     "title": "3 - trd link"}],
    "has_synopsis": false}
    |}]
;;

let%expect_test "test index with rev false" =
  let index = Index.validate @@ index ~sort:(rev false) () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
      "title": "2 - snd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.lol", "url_without_scheme": "xvw.lol"},
     "title": "1 - first link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://github.com", "url_without_scheme": "github.com"},
     "title": "3 - trd link"}],
    "has_synopsis": false}
    |}]
;;

let%expect_test "test index with rev true" =
  let index = Index.validate @@ index ~sort:(rev true) () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://github.com", "url_without_scheme": "github.com"},
      "title": "3 - trd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.lol", "url_without_scheme": "xvw.lol"},
     "title": "1 - first link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
     "title": "2 - snd link"}],
    "has_synopsis": false}
    |}]
;;

let%expect_test "test index with key" =
  let index = Index.validate @@ index ~sort:(sort_by_key "title") () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.lol", "url_without_scheme": "xvw.lol"},
      "title": "1 - first link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
     "title": "2 - snd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://github.com", "url_without_scheme": "github.com"},
     "title": "3 - trd link"}],
    "has_synopsis": false}
    |}]
;;

let%expect_test "test index with key and rev false" =
  let index = Index.validate @@ index ~sort:(full_sort "title" false) () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.lol", "url_without_scheme": "xvw.lol"},
      "title": "1 - first link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
     "title": "2 - snd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://github.com", "url_without_scheme": "github.com"},
     "title": "3 - trd link"}],
    "has_synopsis": false}
    |}]
;;

let%expect_test "test index with key and rev true" =
  let index = Index.validate @@ index ~sort:(full_sort "title" true) () in
  Util.print_normalized_value Index.normalize index;
  [%expect
    {|
    {"name": "My index", "id": "my-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://github.com", "url_without_scheme": "github.com"},
      "title": "3 - trd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.github.io", "url_without_scheme": "xvw.github.io"},
     "title": "2 - snd link"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.lol", "url_without_scheme": "xvw.lol"},
     "title": "1 - first link"}],
    "has_synopsis": false}
    |}]
;;
