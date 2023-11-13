module Fetch = Nightmare_js.Fetch

let ( ~: ) f = f ()

module P = struct
  open Nightmare_service.Path

  let api_v1 () = ~/"api" / "v1"
  let statuses () = ~:api_v1 / "statuses" /: string
  let context () = ~:statuses / "context"
end

let destruct_with_result encoding value =
  try
    let value = Data_encoding.Json.destruct encoding value in
    Ok value
  with exn -> Error (`Json_exn exn)

let get_context domain () =
  Nightmare_service.Endpoint.(outer get) domain ~:P.context

let call_context ~domain ~id =
  let open Dapps.Lwt_util in
  let endpoint = get_context domain in
  let* response = Fetch.from endpoint id in
  if Fetch.Response.is_ok response then
    let+ txt_response = Fetch.Response.text response in
    txt_response
    |> Data_encoding.Json.from_string
    |> Result.map_error (fun message -> `Json_error message)
    |> fun json ->
    Result.bind json @@ destruct_with_result Mastodon.Context.encoding
  else
    let http_status = Fetch.Response.status response in
    return_error (`Http_error http_status)
