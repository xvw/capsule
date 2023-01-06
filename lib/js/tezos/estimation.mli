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

val make_input :
     ?base_fee:Tez.t
  -> gas_limit:Z.t
  -> storage_limit:Z.t
  -> operation_size:Z.t
  -> unit
  -> input

val compute :
     ?minimal_fee:Tez.t
  -> ?gas_buffer:Z.t
  -> ?fee_per_gas:Tez.t
  -> ?fee_per_byte:Tez.t
  -> ?cost_per_byte:Tez.t
  -> input
  -> output

val pp_output : Format.formatter -> output -> unit
