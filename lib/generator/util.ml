let is_empty_list = function [] -> true | _ -> false
let is_not_empty_list x = not (is_empty_list x)

let poor_slug ?(space = "-") str =
  String.fold_left
    (fun acc chr ->
      let chr = Char.lowercase_ascii chr in
      let code = Char.code chr in
      if code >= 48 && code <= 57 then Format.asprintf "%s%c" acc chr
      else if code >= 97 && code <= 122 then Format.asprintf "%s%c" acc chr
      else if code = 32 || code = 45 then acc ^ space
      else acc)
    "" str

let split_at n list =
  if n < 1 then ([], list)
  else
    let rec aux acc n = function
      | [] -> (List.rev acc, [])
      | x :: xs as rest ->
          if n < 1 then (List.rev acc, rest) else aux (x :: acc) (pred n) xs
    in
    aux [] n list

let split_by_size size list =
  let rec aux acc = function
    | [] -> List.rev acc
    | list ->
        let x, xs = split_at size list in
        aux (x :: acc) xs
  in
  aux [] list
