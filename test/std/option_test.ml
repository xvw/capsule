let%expect_test "simple pipeline using Option Infix - 1" =
  let result =
    let open Std.Option in
    Some 10 <|> Some 15 || 20
  in
  print_int result;
  [%expect {| 10 |}]
;;

let%expect_test "simple pipeline using Option Infix - 2" =
  let result =
    let open Std.Option in
    None <|> Some 15 || 20
  in
  print_int result;
  [%expect {| 15 |}]
;;

let%expect_test "simple pipeline using Option Infix - 3" =
  let result =
    let open Std.Option in
    None <|> None || 20
  in
  print_int result;
  [%expect {| 20 |}]
;;
