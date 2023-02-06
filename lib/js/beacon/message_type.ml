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

let to_string = function
  | Acknowledge -> "acknowledge"
  | BroadcastRequest -> "broadcast_request"
  | BroadcastResponse -> "broadcast_response"
  | Disconnect -> "disconnect"
  | Error -> "error"
  | OperationRequest -> "operation_request"
  | OperationResponse -> "operation_response"
  | PermissionRequest -> "permission_request"
  | PermissionResponse -> "permission_response"
  | SignPayloadRequest -> "sign_payload_request"
  | SignPayloadResponse -> "sign_payload_response"

let from_string str =
  match String.(trim (lowercase_ascii str)) with
  | "acknowledge" -> Acknowledge
  | "broadcast_request" -> BroadcastRequest
  | "broadcast_response" -> BroadcastResponse
  | "disconnect" -> Disconnect
  | "error" -> Error
  | "operation_request" -> OperationRequest
  | "operation_response" -> OperationResponse
  | "permission_request" -> PermissionRequest
  | "permission_response" -> PermissionResponse
  | "sign_payload_request" -> SignPayloadRequest
  | "sign_payload_response" -> SignPayloadResponse
  | _ -> Error
