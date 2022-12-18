type t =
  | Acknowledge
  | BroadcastRequest
  | BroadcastResponse
  | Disconnect
  | Error
  | OperationRequest
  | OperationResponse
  | PermissionRequest
  | PermissionResponse
  | SignPayloadRequest
  | SignPayloadResponse

val to_string : t -> string
val from_string : string -> t
