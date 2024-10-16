open Generator.Model

let%expect_test "test validation with only key" =
  let open Yocaml.Data in
  let sort = Sort.validate @@ string "key-name" in
  Util.print_normalized_value Sort.normalize sort;
  [%expect {| {"key": "key-name", "rev": false} |}]
;;

let%expect_test "test validation with only invalid key" =
  let open Yocaml.Data in
  let sort = Sort.validate @@ string "key name" in
  Util.print_normalized_value Sort.normalize sort;
  [%expect {| <error-invalid-shape: record> for `"key name"` |}]
;;

let%expect_test "test validation with only key as record" =
  let open Yocaml.Data in
  let sort = Sort.validate @@ record [ "key", string "key-name" ] in
  Util.print_normalized_value Sort.normalize sort;
  [%expect {| {"key": "key-name", "rev": false} |}]
;;

let%expect_test "test validation with only invalid key as record" =
  let open Yocaml.Data in
  let sort = Sort.validate @@ record [ "key", string "key name" ] in
  Util.print_normalized_value Sort.normalize sort;
  [%expect
    {|
    <error-invalid-record field: key, <error-with-message: key name is not a valid slug> for `key name` for `"key name"`> for `
    {"key": "key name"}`
    |}]
;;

let%expect_test "test validation with key and rev flag as record" =
  let open Yocaml.Data in
  let sort =
    Sort.validate @@ record [ "key", string "key-name"; "rev", bool true ]
  in
  Util.print_normalized_value Sort.normalize sort;
  [%expect {| {"key": "key-name", "rev": true} |}]
;;

let%expect_test "test validation with only rev flag as record" =
  let open Yocaml.Data in
  let sort = Sort.validate @@ record [ "rev", bool true ] in
  Util.print_normalized_value Sort.normalize sort;
  [%expect {| {"key": "<default>", "rev": true} |}]
;;
