type t = Head | Id of string

let head = Head
let from_string x = Id x
let to_string = function Head -> "head" | Id x -> x
let path block_id = "blocks/" ^ to_string block_id
let repr = "blocks/:block_id"
