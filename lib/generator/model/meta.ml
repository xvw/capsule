type t =
  { name : string
  ; content : string
  }

let make ~name ~content = { name; content }
let from_option name = Option.map (fun content -> make ~name ~content)

let from_list name = function
  | [] -> None
  | xs ->
    let content = String.concat ", " xs in
    Some (make ~name ~content)
;;

let normalize { name; content } =
  let open Yocaml.Data in
  record [ "name", string name; "content", string content ]
;;

let normalize_options xs =
  xs |> List.filter_map (Option.map normalize) |> Yocaml.Data.list
;;
