let truncate_link str =
  let len = String.length str in
  if len >= 32 then
    let s = String.sub str 0 32 in
    s ^ "..."
  else str

let rec render_comment_content content =
  let open Nightmare_js_vdom in
  List.map
    (function
      | Util.Text v -> span [ txt v ]
      | Util.Link (h, v) ->
          a
            ~a:[ a_href h; a_class [ "comment-content-link" ] ]
            [ txt @@ truncate_link v ]
      | Util.Paragraph xs ->
          div ~a:[ a_class [ "paragraph" ] ] (render_comment_content xs))
    content

let compute_content content =
  content |> Util.parse_mastodon_response |> render_comment_content

let render_comments main_id comments =
  let open Mastodon in
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "comments-list" ] ]
    (List.map
       (fun comment ->
         let content = comment.Status.content in
         let author = comment.account in
         let username =
           if String.(equal empty author.display_name) then author.username
           else author.display_name
         in
         let txt_content = compute_content content in
         let replies_txt =
           let msg =
             if comment.replies_count > 1 then "reponses" else "reponse"
           in
           string_of_int comment.replies_count ^ " " ^ msg
         in
         div
           ~a:[ a_class [ "a_comment" ]; a_id ("comment-" ^ comment.id) ]
           [
             div
               ~a:[ a_class [ "comment-author-avatar" ] ]
               [ img ~src:author.avatar ~alt:"avatar" () ]
           ; div
               ~a:[ a_class [ "comment-author" ] ]
               [
                 span [ txt username ]
               ; a ~a:[ a_href author.url ] [ txt author.acct ]
               ]
           ; div ~a:[ a_class [ "comment-content" ] ] txt_content
           ; div ~a:[ a_class [ "comment-date" ] ] [ txt comment.created_at ]
           ; div
               ~a:[ a_class [ "comment-stats" ] ]
               [
                 span
                   ~a:[ a_class [ "comment-fav" ] ]
                   [ txt @@ string_of_int comment.favourites_count ]
               ; span
                   ~a:[ a_class [ "comment-re" ] ]
                   [ txt @@ string_of_int comment.reblogs_count ]
               ]
           ; div
               ~a:[ a_class [ "comment-footer" ] ]
               ([
                  a
                    ~a:[ a_href comment.uri; a_class [ "comment-permalink" ] ]
                    [ txt replies_txt ]
                ]
               @
               match comment.in_reply_to_id with
               | Some id when id <> main_id ->
                   [
                     a
                       ~a:
                         [
                           a_href ("#comment-" ^ id)
                         ; a_class [ "comment-to-reply" ]
                         ]
                       [ txt "⮩ en réponse" ]
                   ]
               | _ -> [])
           ])
       comments)

let render_ctx model ctx =
  let open Mastodon in
  let open Nightmare_js_vdom in
  let comments = ctx.Context.descendants in
  let len = List.length comments in
  let suf = if len > 1 then "s" else "" in
  let comment_number = string_of_int len ^ " commentaire" ^ suf in
  let thread_url =
    model.Model.mastodon_instance
    ^ "/@"
    ^ model.Model.mastodon_username
    ^ "/"
    ^ model.Model.mastodon_thread_id
  in
  let thread_link = "https://" ^ thread_url in
  div
    [
      div
        ~a:[ a_class [ "comments-header"; "hyphenate" ] ]
        [
          span ~a:[ a_class [ "comments-number" ] ] [ txt comment_number ]
        ; a
            ~a:[ a_href thread_link; a_class [ "comments-permalink" ] ]
            [ txt thread_url ]
        ]
    ; render_comments model.mastodon_thread_id comments
    ]

let view model =
  let open Nightmare_js_vdom in
  div
    ~a:[ a_class [ "dapp-container" ] ]
    [
      (match model.Model.state with
      | Loading ->
          div
            ~a:[ a_class [ "dapp-loading" ] ]
            [ span [ txt "❖" ]; span [ txt "Chargement des commentaires" ] ]
      | Failed -> div [ txt "Impossible de récupérer les commentaires" ]
      | Fetched context -> render_ctx model context)
    ]
