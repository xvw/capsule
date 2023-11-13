module Visibility = struct
  type t = Public | Unlisted | Private | Direct

  let encoding =
    let open Data_encoding in
    conv
      (function
        | Public -> "public"
        | Unlisted -> "unlisted"
        | Private -> "private"
        | Direct -> "direct")
      (fun str ->
        match String.(trim @@ lowercase_ascii str) with
        | "public" -> Public
        | "unlisted" -> Unlisted
        | "private" -> Private
        | "direct" -> Direct
        | _ -> Public)
      string
end

module Field = struct
  type t = { name : string; value : string; verified_at : string option }

  let encoding =
    let open Data_encoding in
    conv
      (fun { name; value; verified_at } -> (name, value, verified_at))
      (fun (name, value, verified_at) -> { name; value; verified_at })
      (obj3 (req "name" string) (req "value" string) (opt "verified_at" string))
end

module Role = struct
  type t = {
      id : int
    ; color : string
    ; permissions : int64
    ; highlighted : string
  }

  let encoding =
    let open Data_encoding in
    conv
      (fun { id; color; permissions; highlighted } ->
        (id, color, permissions, highlighted))
      (fun (id, color, permissions, highlighted) ->
        { id; color; permissions; highlighted })
      (obj4 (req "id" int31) (req "color" string) (req "permissions" int64)
         (req "highlighted" string))
end

module Custom_emoji = struct
  type t = {
      shortcode : string
    ; url : string
    ; static_url : string
    ; visibile_in_picker : bool
    ; category : string
  }

  let encoding =
    let open Data_encoding in
    conv
      (fun { shortcode; url; static_url; visibile_in_picker; category } ->
        (shortcode, url, static_url, visibile_in_picker, category))
      (fun (shortcode, url, static_url, visibile_in_picker, category) ->
        { shortcode; url; static_url; visibile_in_picker; category })
      (obj5 (req "shortcode" string) (req "url" string)
         (req "static_url" string)
         (req "visibile_in_picker" bool)
         (req "category" string))
end

module Source = struct
  type t = {
      note : string option
    ; fields : Field.t list option
    ; privacy : Visibility.t option
    ; sensitive : bool option
    ; language : string option
    ; follow_request_count : int option
  }

  let encoding =
    let open Data_encoding in
    conv
      (fun { note; fields; privacy; sensitive; language; follow_request_count } ->
        (note, fields, privacy, sensitive, language, follow_request_count))
      (fun (note, fields, privacy, sensitive, language, follow_request_count) ->
        { note; fields; privacy; sensitive; language; follow_request_count })
      (obj6 (opt "note" string)
         (opt "fields" @@ list Field.encoding)
         (opt "privacy" Visibility.encoding)
         (opt "sensitive" bool) (opt "language" string)
         (opt "follow_request_count" int31))
end

module Account = struct
  type t = {
      id : string
    ; username : string
    ; acct : string
    ; url : string
    ; display_name : string
    ; note : string
    ; avatar : string
    ; avatar_static : string
    ; header : string
    ; header_static : string
    ; locked : bool
    ; fields : Field.t list
    ; emojis : Custom_emoji.t list
    ; bot : bool
    ; group : bool
    ; discoverable : bool option
    ; noindex : bool option
    ; moved : t option
    ; suspended : bool
    ; limited : bool
    ; created_at : string
    ; last_status_at : string
    ; statuses_count : int
    ; followers_count : int
    ; following_count : int
    ; source : Source.t
    ; role : Role.t
    ; mute_expires_at : string option
  }

  let encoding =
    let open Data_encoding in
    mu "account" (fun recursion ->
        conv
          (fun {
                 id
               ; username
               ; acct
               ; url
               ; display_name
               ; note
               ; avatar
               ; avatar_static
               ; header
               ; header_static
               ; locked
               ; fields
               ; emojis
               ; bot
               ; group
               ; discoverable
               ; noindex
               ; moved
               ; suspended
               ; limited
               ; created_at
               ; last_status_at
               ; statuses_count
               ; followers_count
               ; following_count
               ; source
               ; role
               ; mute_expires_at
               } ->
            ( ( ( id
                , username
                , acct
                , url
                , display_name
                , note
                , avatar
                , avatar_static
                , header
                , header_static )
              , ( locked
                , fields
                , emojis
                , bot
                , group
                , discoverable
                , noindex
                , moved
                , suspended
                , limited ) )
            , ( created_at
              , last_status_at
              , statuses_count
              , followers_count
              , following_count
              , source
              , role
              , mute_expires_at ) ))
          (fun ( ( ( id
                   , username
                   , acct
                   , url
                   , display_name
                   , note
                   , avatar
                   , avatar_static
                   , header
                   , header_static )
                 , ( locked
                   , fields
                   , emojis
                   , bot
                   , group
                   , discoverable
                   , noindex
                   , moved
                   , suspended
                   , limited ) )
               , ( created_at
                 , last_status_at
                 , statuses_count
                 , followers_count
                 , following_count
                 , source
                 , role
                 , mute_expires_at ) ) ->
            {
              id
            ; username
            ; acct
            ; url
            ; display_name
            ; note
            ; avatar
            ; avatar_static
            ; header
            ; header_static
            ; locked
            ; fields
            ; emojis
            ; bot
            ; group
            ; discoverable
            ; noindex
            ; moved
            ; suspended
            ; limited
            ; created_at
            ; last_status_at
            ; statuses_count
            ; followers_count
            ; following_count
            ; source
            ; role
            ; mute_expires_at
            })
          (merge_objs
             (merge_objs
                (obj10 (req "id" string) (req "username" string)
                   (req "acct" string) (req "url" string)
                   (req "display_name" string)
                   (req "note" string) (req "avatar" string)
                   (req "avatar_static" string)
                   (req "header" string)
                   (req "header_static" string))
                (obj10 (req "locked" bool)
                   (req "fields" @@ list Field.encoding)
                   (req "emojis" @@ list Custom_emoji.encoding)
                   (req "bot" bool) (req "group" bool) (opt "discoverable" bool)
                   (opt "noindex" bool) (opt "moved" recursion)
                   (req "suspended" bool) (req "limited" bool)))
             (obj8 (req "created_at" string)
                (req "last_status_at" string)
                (req "statuses_count" int31)
                (req "followers_count" int31)
                (req "following_count" int31)
                (req "source" Source.encoding)
                (req "role" Role.encoding)
                (opt "mute_expires_at" string))))
end

module Application = struct
  type t = { name : string option; website : string option }

  let encoding =
    let open Data_encoding in
    conv
      (fun { name; website } -> (name, website))
      (fun (name, website) -> { name; website })
      (obj2 (opt "name" string) (opt "website" string))
end

module Mention = struct
  type t = { id : string; username : string; url : string; acct : string }

  let encoding =
    let open Data_encoding in
    conv
      (fun { id; username; url; acct } -> (id, username, url, acct))
      (fun (id, username, url, acct) -> { id; username; url; acct })
      (obj4 (req "id" string) (req "username" string) (req "url" string)
         (req "acct" string))
end

module Tag = struct
  type t = { name : string; url : string }

  let encoding =
    let open Data_encoding in
    conv
      (fun { name; url } -> (name, url))
      (fun (name, url) -> { name; url })
      (obj2 (req "name" string) (req "url" string))
end

module Poll = struct
  type opt = { title : string; votes_count : int }

  type t = {
      id : string
    ; expires_at : string
    ; expired : bool
    ; multiple : bool
    ; votes_count : int
    ; voters_count : int option
    ; options : opt list
    ; emojis : Custom_emoji.t list
    ; voted : bool option
    ; own_votes : int list option
  }

  let opt_encoding =
    let open Data_encoding in
    conv
      (fun { title; votes_count } -> (title, votes_count))
      (fun (title, votes_count) -> { title; votes_count })
      (obj2 (req "title" string) (req "votes_count" int31))

  let encoding =
    let open Data_encoding in
    conv
      (fun {
             id
           ; expires_at
           ; expired
           ; multiple
           ; votes_count
           ; voters_count
           ; options
           ; emojis
           ; voted
           ; own_votes
           } ->
        ( id
        , expires_at
        , expired
        , multiple
        , votes_count
        , voters_count
        , options
        , emojis
        , voted
        , own_votes ))
      (fun ( id
           , expires_at
           , expired
           , multiple
           , votes_count
           , voters_count
           , options
           , emojis
           , voted
           , own_votes ) ->
        {
          id
        ; expires_at
        ; expired
        ; multiple
        ; votes_count
        ; voters_count
        ; options
        ; emojis
        ; voted
        ; own_votes
        })
      (obj10 (req "id" string) (req "expires_at" string) (req "expired" bool)
         (req "multiple" bool) (req "votes_count" int31)
         (opt "voters_count" int31)
         (req "options" @@ list opt_encoding)
         (req "emojis" @@ list Custom_emoji.encoding)
         (opt "voted" bool)
         (opt "own_votes" @@ list int31))
end

module Status = struct
  type t = {
      id : string
    ; uri : string
    ; url : string option
    ; created_at : string
    ; account : Account.t
    ; content : string
    ; visibility : Visibility.t
    ; sensitive : bool
    ; spoiler_text : string
    ; application : Application.t option (**)
    ; mentions : Mention.t list
    ; tags : Tag.t list
    ; emojis : Custom_emoji.t list
    ; reblogs_count : int
    ; favourites_count : int
    ; replies_count : int
    ; in_reply_to_id : string option
    ; in_reply_to_account_id : string option
    ; reblog : t option
    ; poll : Poll.t option (**)
    ; language : string option
    ; text : string option
    ; edited_at : string option
    ; favourited : bool option
    ; reblogged : bool option
    ; muted : bool option
    ; bookmarked : bool option
    ; pinned : bool option (**)
    ; (*
            TO BE COMPLETED
      *)
      media_attachments : unit list (* FIXME: proper media handling *)
    ; card : unit (* FIXME: proper openGraph card handling *)
    ; filtered : unit option (* FIXME: proper filter handling *)
  }

  let encoding =
    let open Data_encoding in
    mu "status" (fun recursion ->
        let fst_slice =
          obj10 (req "id" string) (req "uri" string) (opt "url" string)
            (req "created_at" string)
            (req "account" Account.encoding)
            (req "content" string)
            (req "visibility" Visibility.encoding)
            (req "sensitive" bool)
            (req "spoiler_text" string)
            (opt "application" Application.encoding)
        in
        let snd_slice =
          obj10
            (req "mentions" @@ list Mention.encoding)
            (req "tags" @@ list Tag.encoding)
            (req "emojis" @@ list Custom_emoji.encoding)
            (req "reblogs_count" int31)
            (req "favourites_count" int31)
            (req "replies_count" int31)
            (opt "in_reply_to_id" string)
            (opt "in_reply_to_account_id" string)
            (opt "reblog" recursion) (opt "poll" Poll.encoding)
        in
        let thrd_slice =
          obj8 (opt "language" string) (opt "text" string)
            (opt "edited_at" string) (opt "favourited" bool)
            (opt "reblogged" bool) (opt "muted" bool) (opt "bookmarked" bool)
            (opt "pinned" bool)
        in
        let frth_slice =
          obj3
            (req "media_attachments" @@ list unit)
            (req "card" unit) (opt "filtered" unit)
        in
        let full =
          merge_objs fst_slice
            (merge_objs snd_slice (merge_objs thrd_slice frth_slice))
        in
        let to_tuple
            {
              id
            ; uri
            ; url
            ; created_at
            ; account
            ; content
            ; visibility
            ; sensitive
            ; spoiler_text
            ; application
            ; mentions
            ; tags
            ; emojis
            ; reblogs_count
            ; favourites_count
            ; replies_count
            ; in_reply_to_id
            ; in_reply_to_account_id
            ; reblog
            ; poll
            ; language
            ; text
            ; edited_at
            ; favourited
            ; reblogged
            ; muted
            ; bookmarked
            ; pinned
            ; media_attachments
            ; card
            ; filtered
            } =
          ( ( id
            , uri
            , url
            , created_at
            , account
            , content
            , visibility
            , sensitive
            , spoiler_text
            , application )
          , ( ( mentions
              , tags
              , emojis
              , reblogs_count
              , favourites_count
              , replies_count
              , in_reply_to_id
              , in_reply_to_account_id
              , reblog
              , poll )
            , ( ( language
                , text
                , edited_at
                , favourited
                , reblogged
                , muted
                , bookmarked
                , pinned )
              , (media_attachments, card, filtered) ) ) )
        in

        let from_tuple
            ( ( id
              , uri
              , url
              , created_at
              , account
              , content
              , visibility
              , sensitive
              , spoiler_text
              , application )
            , ( ( mentions
                , tags
                , emojis
                , reblogs_count
                , favourites_count
                , replies_count
                , in_reply_to_id
                , in_reply_to_account_id
                , reblog
                , poll )
              , ( ( language
                  , text
                  , edited_at
                  , favourited
                  , reblogged
                  , muted
                  , bookmarked
                  , pinned )
                , (media_attachments, card, filtered) ) ) ) =
          {
            id
          ; uri
          ; url
          ; created_at
          ; account
          ; content
          ; visibility
          ; sensitive
          ; spoiler_text
          ; application
          ; mentions
          ; tags
          ; emojis
          ; reblogs_count
          ; favourites_count
          ; replies_count
          ; in_reply_to_id
          ; in_reply_to_account_id
          ; reblog
          ; poll
          ; language
          ; text
          ; edited_at
          ; favourited
          ; reblogged
          ; muted
          ; bookmarked
          ; pinned
          ; media_attachments
          ; card
          ; filtered
          }
        in

        conv to_tuple from_tuple full)
end

module Context = struct
  type t = { ancestors : Status.t list; descendants : Status.t list }

  let encoding =
    let open Data_encoding in
    conv
      (fun { ancestors; descendants } -> (ancestors, descendants))
      (fun (ancestors, descendants) -> { ancestors; descendants })
      (obj2
         (req "ancestors" @@ list Status.encoding)
         (req "descendants" @@ list Status.encoding))
end
