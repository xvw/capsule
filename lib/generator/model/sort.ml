type t =
  { key : Yocaml.Slug.t
  ; rev : bool
  }

let validate =
  let open Yocaml.Data.Validation in
  (Yocaml.Slug.validate $ fun key -> { key; rev = false })
  / record (fun fields ->
    let+ key =
      optional_or ~default:"<default>" fields "key" Yocaml.Slug.validate
    and+ rev = optional_or ~default:false fields "rev" bool in
    { key; rev })
;;

let normalize { key; rev } =
  let open Yocaml.Data in
  record [ "key", string key; "rev", bool rev ]
;;

let key { key; _ } = key
let is_rev { rev; _ } = rev
