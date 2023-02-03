let z_hundred = Z.of_int 100
let default_minimal_fee = Tez.Micro.from_int' 100
let default_minimal_fee_per_byte = Tez.Micro.from_int' 1
let default_cost_per_byte = Tez.Micro.from_int' 250
let default_minimal_fee_ber_gas = Tez.Nano.from_int' 100
let default_gas_buffer = z_hundred

type input = {
    gas_limit : Z.t
  ; storage_limit : Z.t
  ; operation_size : Z.t
  ; base_fee : Tez.t
}

type output = {
    burn_fee : Tez.t
  ; minimal_fee : Tez.t
  ; minimal_fee_using_base : Tez.t
  ; suggested_fee : Tez.t
  ; total_fee : Tez.t
}

let storage_limit { storage_limit; _ } = Z.max storage_limit Z.zero

let gas_limit ?(gas_buffer = default_gas_buffer) { gas_limit; _ } =
  Z.(gas_limit * gas_buffer)

let make_input ?(base_fee = default_minimal_fee) ~gas_limit ~storage_limit
    ~operation_size () =
  { gas_limit; storage_limit; operation_size; base_fee }

let compute_burn_fee ?(cost_per_byte = default_cost_per_byte) input =
  Z.(Tez.to_z cost_per_byte * storage_limit input) |> Tez.Micro.from_z'

let compute_operation_fee ?gas_buffer
    ?(fee_per_gas = default_minimal_fee_ber_gas)
    ?(fee_per_byte = default_minimal_fee_per_byte)
    ({ operation_size; _ } as input) =
  Z.(
    (gas_limit ?gas_buffer input * Tez.to_z fee_per_gas)
    + (operation_size * Tez.to_z fee_per_byte))

let compute_minimal_fee ?(minimal_fee = default_minimal_fee) ?gas_buffer
    ?fee_per_gas ?fee_per_byte input =
  Z.(
    compute_operation_fee ?gas_buffer ?fee_per_gas ?fee_per_byte input
    + Tez.to_z minimal_fee)
  |> Tez.Micro.from_z'

let compute_suggested_fee ?(minimal_fee = default_minimal_fee) ?gas_buffer
    ?fee_per_gas ?fee_per_byte input =
  Z.(
    compute_operation_fee ?gas_buffer ?fee_per_gas ?fee_per_byte input
    + (Tez.to_z minimal_fee * Z.of_int 2))
  |> Tez.Micro.from_z'

let compute_total ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte
    ?cost_per_byte input =
  let burn = compute_burn_fee ?cost_per_byte input
  and minimal =
    compute_minimal_fee ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte
      input
  in
  Tez.(burn + minimal)

let compute ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte ?cost_per_byte
    ({ base_fee; _ } as input) =
  let with_base_fee =
    Tez.max (Option.value ~default:default_minimal_fee minimal_fee) base_fee
  in
  {
    burn_fee = compute_burn_fee ?cost_per_byte input
  ; minimal_fee =
      compute_minimal_fee ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte
        input
  ; minimal_fee_using_base =
      compute_minimal_fee ~minimal_fee:with_base_fee ?gas_buffer ?fee_per_gas
        ?fee_per_byte input
  ; suggested_fee =
      compute_suggested_fee ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte
        input
  ; total_fee =
      compute_total ?minimal_fee ?gas_buffer ?fee_per_gas ?fee_per_byte input
  }

let pp_output ppf
    { burn_fee; minimal_fee; minimal_fee_using_base; suggested_fee; total_fee }
    =
  Format.fprintf ppf
    "{ burn_fee = %a; minimal_fee = %a; minimal_fee_using_base = %a;  \
     suggested_fee = %a; total_fee = %a}"
    Tez.pp burn_fee Tez.pp minimal_fee Tez.pp minimal_fee_using_base Tez.pp
    suggested_fee Tez.pp total_fee
