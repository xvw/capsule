val call_context :
     domain:string
  -> id:string
  -> ( Mastodon.Context.t
     , [> `Json_error of string | `Json_exn of exn | `Http_error of int ] )
     result
     Lwt.t
