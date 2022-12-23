type t = {
    hash : string
  ; level : int
  ; proto : int
  ; predecessor : string
  ; timestamp : string
  ; validation_pass : int
  ; operations_hash : string
  ; fitness : string list
  ; context : string
  ; protocol_data : string
}

let inj
    {
      hash
    ; level
    ; proto
    ; predecessor
    ; timestamp
    ; validation_pass
    ; operations_hash
    ; fitness
    ; context
    ; protocol_data
    } =
  ( hash
  , level
  , proto
  , predecessor
  , timestamp
  , validation_pass
  , operations_hash
  , fitness
  , context
  , protocol_data )

let proj
    ( hash
    , level
    , proto
    , predecessor
    , timestamp
    , validation_pass
    , operations_hash
    , fitness
    , context
    , protocol_data ) =
  {
    hash
  ; level
  ; proto
  ; predecessor
  ; timestamp
  ; validation_pass
  ; operations_hash
  ; fitness
  ; context
  ; protocol_data
  }

let encoding =
  let open Data_encoding in
  conv inj proj
    (obj10 (req "hash" string) (req "level" int31) (req "proto" int8)
       (req "predecessor" string) (req "timestamp" string)
       (req "validation_pass" int8)
       (req "operations_hash" string)
       (req "fitness" (list ?max_length:None string))
       (req "context" string)
       (req "protocol_data" string))
