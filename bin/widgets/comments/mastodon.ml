let ignore_extra_fields e =
  let open Data_encoding in
  conv (fun x -> (x, ())) (fun (x, ()) -> x) @@ merge_objs e unit

module Account = struct
  type t = {
      id : string
    ; username : string
    ; acct : string
    ; url : string
    ; display_name : string
    ; note : string
    ; avatar : string
    ; bot : bool
  }

  let encoding =
    let open Data_encoding in
    let prism =
      conv
        (fun { id; username; acct; url; display_name; note; avatar; bot } ->
          (id, username, acct, url, display_name, note, avatar, bot))
        (fun (id, username, acct, url, display_name, note, avatar, bot) ->
          { id; username; acct; url; display_name; note; avatar; bot })
        (obj8 (req "id" string) (req "username" string) (req "acct" string)
           (req "url" string)
           (req "display_name" string)
           (req "note" string) (req "avatar" string) (req "bot" bool))
    in
    ignore_extra_fields prism
end

module Mention = struct
  type t = { id : string; username : string; url : string; acct : string }

  let encoding =
    let open Data_encoding in
    let prism =
      conv
        (fun { id; username; url; acct } -> (id, username, url, acct))
        (fun (id, username, url, acct) -> { id; username; url; acct })
        (obj4 (req "id" string) (req "username" string) (req "url" string)
           (req "acct" string))
    in
    ignore_extra_fields prism
end

module Tag = struct
  type t = { name : string; url : string }

  let encoding =
    let open Data_encoding in
    let prism =
      conv
        (fun { name; url } -> (name, url))
        (fun (name, url) -> { name; url })
        (obj2 (req "name" string) (req "url" string))
    in
    ignore_extra_fields prism
end

module Status = struct
  type t = {
      id : string
    ; uri : string
    ; created_at : string
    ; account : Account.t
    ; content : string
    ; mentions : Mention.t list
    ; tags : Tag.t list
    ; reblogs_count : int
    ; favourites_count : int
    ; replies_count : int
    ; in_reply_to_id : string option
  }

  let encoding =
    let open Data_encoding in
    let fst_slice =
      obj6 (req "id" string) (req "uri" string) (req "created_at" string)
        (req "account" Account.encoding)
        (req "content" string)
        (req "mentions" @@ list Mention.encoding)
    and snd_slice =
      obj5
        (req "tags" @@ list Tag.encoding)
        (req "reblogs_count" int31)
        (req "favourites_count" int31)
        (req "replies_count" int31)
        (opt "in_reply_to_id" string)
    in
    let obj = merge_objs fst_slice snd_slice in
    let prism =
      conv
        (fun {
               id
             ; uri
             ; created_at
             ; account
             ; content
             ; mentions
             ; tags
             ; reblogs_count
             ; favourites_count
             ; replies_count
             ; in_reply_to_id
             } ->
          ( (id, uri, created_at, account, content, mentions)
          , ( tags
            , reblogs_count
            , favourites_count
            , replies_count
            , in_reply_to_id ) ))
        (fun ( (id, uri, created_at, account, content, mentions)
             , ( tags
               , reblogs_count
               , favourites_count
               , replies_count
               , in_reply_to_id ) ) ->
          {
            id
          ; uri
          ; created_at
          ; account
          ; content
          ; mentions
          ; tags
          ; reblogs_count
          ; favourites_count
          ; replies_count
          ; in_reply_to_id
          })
        obj
    in
    ignore_extra_fields prism
end

module Context = struct
  type t = { ancestors : Status.t list; descendants : Status.t list }

  let encoding =
    let open Data_encoding in
    let prism =
      conv
        (fun { ancestors; descendants } -> (ancestors, descendants))
        (fun (ancestors, descendants) -> { ancestors; descendants })
        (obj2
           (req "ancestors" @@ list Status.encoding)
           (req "descendants" @@ list Status.encoding))
    in
    ignore_extra_fields prism
end

type content_fragment =
  | Text of string
  | Mention of string
  | Tag of string
  | Link of (string * string)

let fragmentize str =
  let len = String.length str in
  let rec aux acc previous i =
    if i >= len then List.rev (Text previous :: acc)
    else
      let car = str.[i] in
      match car with
      | '@' ->
          let mention, new_i = lex_token "" (succ i) in
          aux (Mention mention :: Text previous :: acc) "" new_i
      | '#' ->
          let tag, new_i = lex_token "" (succ i) in
          aux (Tag tag :: Text previous :: acc) "" new_i
      | c -> aux acc (String.cat previous @@ String.make 1 c) (succ i)
  and lex_token acc i =
    if i >= len then (acc, i)
    else
      let car = str.[i] in
      match car with
      | '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' | '-' | '_' ->
          lex_token (String.cat acc (String.make 1 car)) (succ i)
      | _ -> (acc, i)
  in
  aux [] "" 0
