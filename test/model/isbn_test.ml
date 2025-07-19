open Generator.Model

let%expect_test "Invalid ISBN" =
  let isbn = Isbn.validate @@ Yocaml.Data.string "fooo bar" in
  Util.print_normalized_value Isbn.normalize isbn;
  [%expect {| <error-with-message: Invalid ISBN> for `fooo bar` |}]
;;

let%expect_test "valid ISBN 13" =
  let isbn = Isbn.validate @@ Yocaml.Data.string "9782492042249" in
  Util.print_normalized_value Isbn.normalize isbn;
  [%expect
    {|
    {"target":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://isbnsearch.org/isbn/9782492042249", "url_without_scheme":
      "isbnsearch.org/isbn/9782492042249"},
    "value": "9782492042249", "repr": "978-2-4920-4224-9"}
    |}]
;;

let%expect_test "valid ISBN 10" =
  let isbn = Isbn.validate @@ Yocaml.Data.string "2492042243" in
  Util.print_normalized_value Isbn.normalize isbn;
  [%expect
    {|
    {"target":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://isbnsearch.org/isbn/2492042243", "url_without_scheme":
      "isbnsearch.org/isbn/2492042243"},
    "value": "2492042243", "repr": "2-4920-4224-3"}
    |}]
;;

let%expect_test "valid ISBN 13 with random spaces" =
  let isbn = Isbn.validate @@ Yocaml.Data.string "978 249-20422:4--9" in
  Util.print_normalized_value Isbn.normalize isbn;
  [%expect
    {|
    {"target":
     {"kind": "external", "has_scheme": true, "scheme": "https", "url":
      "https://isbnsearch.org/isbn/9782492042249", "url_without_scheme":
      "isbnsearch.org/isbn/9782492042249"},
    "value": "9782492042249", "repr": "978-2-4920-4224-9"}
    |}]
;;
