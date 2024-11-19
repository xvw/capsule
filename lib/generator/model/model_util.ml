open Yocaml

let exists_from_opt x = x |> Option.is_some |> Data.bool
let exists_from_list x = Data.bool (not (List.is_empty x))

let minimal_length ~length value =
  let open Yocaml.Data.Validation in
  where (fun x -> Int.compare (length x) value >= 0)
;;
