let minimal_fees = Tez.of_mutez (Z.of_int 100)
let minimal_fees_per_gas_unit = Tez.of_nanotez (Z.of_int 100)
let minimal_fees_per_byte = Tez.of_mutez Z.one

type config = {
    minimal_fees : Tez.t
  ; minimal_fees_per_gas_unit : Tez.t
  ; minimal_fees_per_byte : Tez.t
}

let make_config ~minimal_fees ~minimal_fees_per_gas_unit ~minimal_fees_per_byte
    =
  { minimal_fees; minimal_fees_per_byte; minimal_fees_per_gas_unit }

let default_config =
  make_config ~minimal_fees ~minimal_fees_per_gas_unit ~minimal_fees_per_byte
