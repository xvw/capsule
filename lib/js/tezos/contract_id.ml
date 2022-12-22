type t = string

let from_string x = x
let to_string x = x
let path contract_id = "contracts/" ^ to_string contract_id
let repr = "contracts/:contract_id"
