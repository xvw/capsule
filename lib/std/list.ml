let split_at n list =
  if n < 1
  then [], list
  else (
    let rec aux acc n = function
      | [] -> Stdlib.List.rev acc, []
      | x :: xs as rest ->
        if n < 1 then Stdlib.List.rev acc, rest else aux (x :: acc) (pred n) xs
    in
    aux [] n list)
;;

let split_by_size size list =
  let rec aux acc = function
    | [] -> Stdlib.List.rev acc
    | list ->
      let x, xs = split_at size list in
      aux (x :: acc) xs
  in
  aux [] list
;;

let textual_join sep to_string list =
  let rec aux r acc = function
    | [] -> ""
    | [ x ] ->
      acc
      ^ sep
          (to_string x)
          (match r with
           | `First -> `First
           | _ -> `Last)
    | x :: xs -> aux `Regular (acc ^ sep (to_string x) r) xs
  in
  aux `First "" list
;;

let textual_enum ?(last = "and") =
  textual_join (fun elt -> function
    | `First -> elt
    | `Regular -> ", " ^ elt
    | `Last -> " " ^ last ^ " " ^ elt)
;;
