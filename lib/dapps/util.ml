let truncate_hash str =
  let len = String.length str in
  let off = len - 4 in
  let fst = String.sub str 0 8 in
  let lst = String.sub str off 4 in
  fst ^ ".." ^ lst

let block_hash_to_string x =
  x |> Yourbones.Block_hash.to_string |> truncate_hash
