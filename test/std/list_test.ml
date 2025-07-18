let pp_list pp ppf list =
  let pplist =
    Format.pp_print_list ~pp_sep:(fun ppf () -> Format.fprintf ppf ";") pp
  in
  Format.fprintf ppf "[%a]" pplist list
;;

let dump list = Format.printf "%a" (pp_list (pp_list Format.pp_print_int)) list

let%expect_test "Splitting empty list" =
  dump @@ Std.List.split_by_size 3 [];
  [%expect {| [] |}]
;;

let%expect_test "Splitting list - 1" =
  dump @@ Std.List.split_by_size 1 [ 1; 2; 3; 4; 5 ];
  [%expect {| [[1];[2];[3];[4];[5]] |}]
;;

let%expect_test "Splitting list - 2" =
  dump
  @@ Std.List.split_by_size
       3
       [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15 ];
  [%expect {| [[1;2;3];[4;5;6];[7;8;9];[10;11;12];[13;14;15]] |}]
;;

let%expect_test "Splitting list - 2" =
  dump
  @@ Std.List.split_by_size 4 [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 14; 15 ];
  [%expect {| [[1;2;3;4];[5;6;7;8];[9;10;11;12];[14;15]] |}]
;;

let%expect_test "textual_enum on empty list" =
  print_endline @@ Std.List.textual_enum (fun x -> x) []
;;

let%expect_test "textual_enum on one element" =
  print_endline @@ Std.List.textual_enum (fun x -> x) [ "foo" ];
  [%expect {| foo |}]
;;

let%expect_test "textual_enum on two elements" =
  print_endline @@ Std.List.textual_enum (fun x -> x) [ "foo"; "bar" ];
  [%expect {| foo and bar |}]
;;

let%expect_test "textual_enum on three elements" =
  print_endline @@ Std.List.textual_enum (fun x -> x) [ "foo"; "bar"; "baz" ];
  [%expect {| foo, bar and baz |}]
;;

let%expect_test "textual_enum on three elements in french" =
  print_endline
  @@ Std.List.textual_enum ~last:"et" (fun x -> x) [ "foo"; "bar"; "baz" ];
  [%expect {| foo, bar et baz |}]
;;
