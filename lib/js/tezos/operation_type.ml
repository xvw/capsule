type t =
  | ENDORSEMENT
  | SEED_NONCE_REVELATION
  | DOUBLE_ENDORSEMENT_EVIDENCE
  | DOUBLE_BAKING_EVIDENCE
  | ACTIVATE_ACCOUNT
  | PROPOSALS
  | BALLOT
  | REVEAL
  | TRANSACTION
  | ORIGINATION
  | DELEGATION

let to_string = function
  | ENDORSEMENT -> "endorsement"
  | SEED_NONCE_REVELATION -> "seed_nonce_revelation"
  | DOUBLE_ENDORSEMENT_EVIDENCE -> "double_endorsement_evidence"
  | DOUBLE_BAKING_EVIDENCE -> "double_baking_evidence"
  | ACTIVATE_ACCOUNT -> "activate_account"
  | PROPOSALS -> "proposals"
  | BALLOT -> "ballot"
  | REVEAL -> "reveal"
  | TRANSACTION -> "transaction"
  | ORIGINATION -> "origination"
  | DELEGATION -> "delegation"

let from_string value =
  match String.(trim @@ lowercase_ascii value) with
  | "endorsement" -> Some ENDORSEMENT
  | "seed_nonce_revelation" -> Some SEED_NONCE_REVELATION
  | "double_endorsement_evidence" -> Some DOUBLE_ENDORSEMENT_EVIDENCE
  | "double_baking_evidence" -> Some DOUBLE_BAKING_EVIDENCE
  | "activate_account" -> Some ACTIVATE_ACCOUNT
  | "proposals" -> Some PROPOSALS
  | "ballot" -> Some BALLOT
  | "reveal" -> Some REVEAL
  | "transaction" -> Some TRANSACTION
  | "origination" -> Some ORIGINATION
  | "delegation" -> Some DELEGATION
  | _ -> None

let tag = function
  | ENDORSEMENT -> 21
  | SEED_NONCE_REVELATION -> 1
  | DOUBLE_ENDORSEMENT_EVIDENCE -> 2
  | DOUBLE_BAKING_EVIDENCE -> 3
  | ACTIVATE_ACCOUNT -> 4
  | PROPOSALS -> 5
  | BALLOT -> 6
  | REVEAL -> 107
  | TRANSACTION -> 108
  | ORIGINATION -> 109
  | DELEGATION -> 110
