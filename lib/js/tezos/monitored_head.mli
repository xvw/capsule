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

val encoding : t Data_encoding.t
