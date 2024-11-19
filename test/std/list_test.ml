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
