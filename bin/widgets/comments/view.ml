let render_mention mentions username =
  let open Nightmare_js_vdom in
  match
    List.find_opt
      (fun x -> String.equal x.Mastodon.Mention.username username)
      mentions
  with
  | Some s ->
      a
        ~a:[ a_href s.url; a_class [ "comment-content-mention" ] ]
        [ txt @@ "@" ^ username ]
  | None ->
      span
        ~a:
          [
            a_class
              [ "comment-content-mention"; "comment-content-mention-unreach" ]
          ]
        [ txt @@ "#" ^ username ]

let render_tag tags username =
  let open Nightmare_js_vdom in
  match
    List.find_opt (fun x -> String.equal x.Mastodon.Tag.name username) tags
  with
  | Some s ->
      a
        ~a:[ a_href s.url; a_class [ "comment-content-tag" ] ]
        [ txt @@ "#" ^ username ]
  | None ->
      span
        ~a:[ a_class [ "comment-content-tag"; "comment-content-tag-unreach" ] ]
        [ txt @@ "#" ^ username ]

let compute_content tags mentions content =
  let open Nightmare_js_vdom in
  content
  |> Util.cheat_with_string_document
  |> Mastodon.fragmentize
  |> List.filter_map (function
       | Mastodon.Tag x -> Some (render_tag tags x)
       | Mention x -> Some (render_mention mentions x)
       | Text "" -> None
       | Text x ->
           Some (span ~a:[ a_class [ "comment-content-regular" ] ] [ txt x ]))

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
         let txt_content =
           compute_content comment.tags comment.mentions content
         in
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
        ~a:[ a_class [ "comments-header" ] ]
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
