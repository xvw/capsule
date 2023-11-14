type state = Loading | Fetched of Mastodon.Context.t | Failed

type t = {
    mastodon_instance : string
  ; mastodon_username : string
  ; mastodon_thread_id : string
  ; state : state
}

let init mastodon_instance mastodon_username mastodon_thread_id =
  let state = Loading in
  { mastodon_instance; mastodon_username; mastodon_thread_id; state }
  |> Vdom.return
       ~c:
         [
           Command.fetch_context ~mastodon_instance ~mastodon_thread_id
             ~on_success:(fun ctx -> Message.Retreived_comments ctx)
             ~on_failure:(fun _ -> Message.Failed_retreived_comments)
         ]

let update model = function
  | Message.Failed_retreived_comments ->
      Vdom.return { model with state = Failed }
  | Message.Retreived_comments ctx ->
      Vdom.return { model with state = Fetched ctx }
