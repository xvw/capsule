type t = Index.t list

let sort_by indexes = function
  | None -> indexes
  | Some Sort.{ key; rev } ->
    let indexes =
      match key with
      | "index-name" | "index-title" | "name" | "title" ->
        List.sort
          (fun a b ->
            let f = if rev then -1 else 1 in
            f * Index.compare_by_name a b)
          indexes
      | "index-id" | "index-key" | "id" | "key" ->
        List.sort
          (fun a b ->
            let f = if rev then -1 else 1 in
            f * Index.compare_by_id a b)
          indexes
      | "index-size" | "index-length" | "size" | "length" ->
        List.sort
          (fun a b ->
            let f = if rev then -1 else 1 in
            f * Index.compare_by_size a b)
          indexes
      | _ -> if rev then List.rev indexes else indexes
    in
    indexes
;;

let validate =
  let open Yocaml.Data.Validation in
  list_of Index.validate
  / record (fun fields ->
    let+ sort = optional fields "sort" Sort.validate
    and+ indexes = required fields "list" (list_of Index.validate) in
    sort_by indexes sort)
;;

let normalize indexes =
  let open Yocaml.Data in
  list_of Index.normalize indexes
;;
