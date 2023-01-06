type t = { cost_per_byte : Tez.t; origination_size : int }

let cost_per_byte { cost_per_byte; _ } = cost_per_byte
let origination_size { origination_size; _ } = origination_size

let default =
  { cost_per_byte = Tez.of_mutez @@ Z.of_int 250; origination_size = 257 }

let encoding =
  let open Data_encoding in
  conv
    (fun { cost_per_byte; origination_size } ->
      ((cost_per_byte, origination_size), ()))
    (fun ((cost_per_byte, origination_size), ()) ->
      { cost_per_byte; origination_size })
    (merge_objs
       (obj2 (req "cost_per_byte" Tez.encoding) (req "origination_size" int31))
       unit)
