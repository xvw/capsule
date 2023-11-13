type 'msg Vdom.Cmd.t +=
  | Fetch_context of {
        mastodon_instance : string
      ; mastodon_thread_id : string
      ; on_success : Mastodon.Context.t -> 'msg
      ; on_failure :
             [ `Json_error of string | `Json_exn of exn | `Http_error of int ]
          -> 'msg
    }

let perform_fetch_context domain id ctx on_success on_failure () =
  let open Dapps.Lwt_util in
  let+ pctxt = Endpoint.call_context ~domain ~id in
  let message =
    match pctxt with Error err -> on_failure err | Ok c -> on_success c
  in
  Vdom_blit.Cmd.send_msg ctx message

let register () =
  let open Vdom_blit in
  let handler ctx = function
    | Fetch_context
        { mastodon_instance; mastodon_thread_id; on_success; on_failure } ->
        let () =
          Lwt.dont_wait
            (perform_fetch_context mastodon_instance mastodon_thread_id ctx
               on_success on_failure)
            Nightmare_js.Console.error
        in
        true
    | _ -> false
  in
  register @@ cmd Cmd.{ f = handler }

let fetch_context ~mastodon_instance ~mastodon_thread_id ~on_success ~on_failure
    =
  Fetch_context
    { mastodon_instance; mastodon_thread_id; on_failure; on_success }
