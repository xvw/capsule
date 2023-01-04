type t = { cost_per_byte : Tez.t }

let cost_per_byte { cost_per_byte; _ } = cost_per_byte

let encoding =
  let open Data_encoding in
  conv
    (fun { cost_per_byte } -> (cost_per_byte, ()))
    (fun (cost_per_byte, ()) -> { cost_per_byte })
    (merge_objs (obj1 (req "cost_per_byte" Tez.encoding)) unit)
