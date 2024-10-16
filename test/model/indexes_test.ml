open Generator.Model

let may_cons key f x xs =
  match x with
  | None -> xs
  | Some x -> (key, f x) :: xs
;;

let link = Index_test.link

let indexes ?sort idxs =
  let open Yocaml.Data in
  match sort with
  | None -> list idxs
  | Some sort -> record [ "sort", sort; "list", list idxs ]
;;

let index ?sort ?id ?synopsis name links =
  let open Yocaml.Data in
  let list = [ "name", string name; "links", list links ] in
  list
  |> may_cons "sort" Fun.id sort
  |> may_cons "id" string id
  |> may_cons "synopsis" string synopsis
  |> record
;;

let%expect_test "test without any sort" =
  let indexes =
    Indexes.validate
    @@ indexes
         [ index "A first index" [ link "a" "https://xvw.lol" ]
         ; index
             "A second index"
             [ link "a" "https://xvw.lol"; link "b" "https://xvw.lol/foo" ]
         ]
  in
  Util.print_normalized_value Indexes.normalize indexes;
  [%expect
    {|
    [{"name": "A first index", "id": "a-first-index", "synopsis": null, "links":
      [{"url":
        {"kind": "external", "has_scheme": true, "scheme": "https", "url":
         "https://xvw.lol", "url_without_scheme": "xvw.lol"},
       "title": "a"}],
     "size": 1, "has_synopsis": false, "has_links": true},
    {"name": "A second index", "id": "a-second-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.lol", "url_without_scheme": "xvw.lol"},
      "title": "a"},
     {"url":
      {"kind": "external", "has_scheme": true, "scheme": "https", "url":
       "https://xvw.lol/foo", "url_without_scheme": "xvw.lol/foo"},
     "title": "b"}],
    "size": 2, "has_synopsis": false, "has_links": true}]
    |}]
;;

let%expect_test "test with a size-sort" =
  let indexes =
    Indexes.validate
    @@ indexes
         ~sort:(Index_test.full_sort "size" true)
         [ index "A first index" [ link "a" "https://xvw.lol" ]
         ; index
             "A second index"
             [ link "a" "https://xvw.lol"; link "b" "https://xvw.lol/foo" ]
         ]
  in
  Util.print_normalized_value Indexes.normalize indexes;
  [%expect
    {|
    [{"name": "A second index", "id": "a-second-index", "synopsis": null,
     "links":
      [{"url":
        {"kind": "external", "has_scheme": true, "scheme": "https", "url":
         "https://xvw.lol", "url_without_scheme": "xvw.lol"},
       "title": "a"},
      {"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.lol/foo", "url_without_scheme": "xvw.lol/foo"},
      "title": "b"}],
     "size": 2, "has_synopsis": false, "has_links": true},
    {"name": "A first index", "id": "a-first-index", "synopsis": null, "links":
     [{"url":
       {"kind": "external", "has_scheme": true, "scheme": "https", "url":
        "https://xvw.lol", "url_without_scheme": "xvw.lol"},
      "title": "a"}],
    "size": 1, "has_synopsis": false, "has_links": true}]
    |}]
;;
