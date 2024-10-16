open Generator.Model

let%expect_test "validate a key-value of an empty list" =
  let open Yocaml.Data in
  let kv = Key_value.String.validate @@ list [] in
  Util.print_normalized_value Key_value.String.normalize kv;
  [%expect {| [] |}]
;;

let%expect_test "validate a key-value using full repr" =
  let open Yocaml.Data in
  let kv =
    Key_value.String.validate
    @@ list
         [ record [ "key", string "a"; "value", string "a value" ]
         ; record [ "key", string "b"; "value", string "b value" ]
         ; record [ "key", string "c"; "value", string "c value" ]
         ]
  in
  Util.print_normalized_value Key_value.String.normalize kv;
  [%expect
    {|
    [{"key": "a", "value": "a value"}, {"key": "b", "value": "b value"},
    {"key": "c", "value": "c value"}]
    |}]
;;

let%expect_test "validate a key-value using compact repr" =
  let open Yocaml.Data in
  let kv =
    Key_value.String.validate
    @@ list
         [ list [ string "a"; string "a value" ]
         ; list [ string "b"; string "b value" ]
         ; list [ string "c"; string "c value" ]
         ]
  in
  Util.print_normalized_value Key_value.String.normalize kv;
  [%expect
    {|
    [{"key": "a", "value": "a value"}, {"key": "b", "value": "b value"},
    {"key": "c", "value": "c value"}]
    |}]
;;
