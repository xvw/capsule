type state = Loading

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

let update model _ = Vdom.return model
