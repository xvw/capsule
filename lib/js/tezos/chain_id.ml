type t = Main | Id of string

let main = Main
let from_string x = Id x
let to_string = function Main -> "main" | Id x -> x
let path chain_id = "chains/" ^ to_string chain_id
let repr = "chains/:chain_id"
