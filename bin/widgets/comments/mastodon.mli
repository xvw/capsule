(** Partial Bininding of Mastodon API for Comments handling using Context of a
    thread *)

module Visibility : sig
  type t = Public | Unlisted | Private | Direct

  val encoding : t Data_encoding.t
end

module Field : sig
  type t = { name : string; value : string; verified_at : string option }

  val encoding : t Data_encoding.t
end

module Role : sig
  type t = {
      id : int
    ; color : string
    ; permissions : int64
    ; highlighted : string
  }

  val encoding : t Data_encoding.t
end

module Custom_emoji : sig
  type t = {
      shortcode : string
    ; url : string
    ; static_url : string
    ; visibile_in_picker : bool
    ; category : string
  }

  val encoding : t Data_encoding.t
end

module Source : sig
  type t = {
      note : string option
    ; fields : Field.t list option
    ; privacy : Visibility.t option
    ; sensitive : bool option
    ; language : string option
    ; follow_request_count : int option
  }

  val encoding : t Data_encoding.t
end

module Account : sig
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

  val encoding : t Data_encoding.t
end

module Application : sig
  type t = { name : string option; website : string option }

  val encoding : t Data_encoding.t
end

module Mention : sig
  type t = { id : string; username : string; url : string; acct : string }

  val encoding : t Data_encoding.t
end

module Tag : sig
  type t = { name : string; url : string }

  val encoding : t Data_encoding.t
end

module Poll : sig
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

  val encoding : t Data_encoding.t
  val opt_encoding : opt Data_encoding.t
end

module Status : sig
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
    ; application : Application.t option
    ; mentions : Mention.t list
    ; tags : Tag.t list
    ; emojis : Custom_emoji.t list
    ; reblogs_count : int
    ; favourites_count : int
    ; replies_count : int
    ; in_reply_to_id : string option
    ; in_reply_to_account_id : string option
    ; reblog : t option
    ; poll : Poll.t option
    ; language : string option
    ; text : string option
    ; edited_at : string option
    ; favourited : bool option
    ; reblogged : bool option
    ; muted : bool option
    ; bookmarked : bool option
    ; pinned : bool option
    ; media_attachments : unit list
    ; card : unit
    ; filtered : unit option
  }

  val encoding : t Data_encoding.t
end

module Context : sig
  type t = { ancestors : Status.t list; descendants : Status.t list }

  val encoding : t Data_encoding.t
end
