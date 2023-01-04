(** RPC entrypoint description. *)

type error = [ `Json_error of string | `Json_exn of exn | `Http_error of int ]

type retention_policy =
  | Raise of (exn -> (unit, error) result Lwt.t)
  | Restart of float

(** {1 Call an RPC entrypoint} *)

val make_call :
     network:Network.t
  -> entrypoint:
       (   unit
        -> ('meth, 'encoding, 'b, ('encoding, error) result Lwt.t) Entrypoint.t)
  -> 'b

val make_call_head :
     network:Network.t
  -> entrypoint:
       (   unit
        -> ( 'meth
           , 'encoding
           , Chain_id.t -> Block_id.t -> 'b
           , ('encoding, error) result Lwt.t )
           Entrypoint.t)
  -> 'b

val is_reachable :
     network:Network.t
  -> entrypoint:(unit -> ('meth, 'encoding, 'b, bool Lwt.t) Entrypoint.t)
  -> 'b

val is_reachable_head :
     network:Network.t
  -> entrypoint:
       (   unit
        -> ( 'meth
           , 'encoding
           , Chain_id.t -> Block_id.t -> 'b
           , bool Lwt.t )
           Entrypoint.t)
  -> 'b

val make_stream :
     ?retention_policy:retention_policy
  -> network:Network.t
  -> entrypoint:
       (   unit
        -> ( [< `DELETE | `GET | `PATCH | `POST ]
           , 'a
           , 'b
           , (unit, error) result Lwt.t )
           Entrypoint.t)
  -> on_chunk:('a -> (unit, error) result Lwt.t)
  -> 'b

(** {1 RPC Directory} *)

val get_balance :
     unit
  -> ( [ `GET ]
     , Tez.t
     , Chain_id.t -> Block_id.t -> Contract_id.t -> 'a
     , 'a )
     Entrypoint.t

val get_parametric_constants :
     unit
  -> ([ `GET ], Constants.t, Chain_id.t -> Block_id.t -> 'a, 'a) Entrypoint.t

val monitor_heads : unit -> ([ `GET ], Monitored_head.t, 'a, 'a) Entrypoint.t
