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
