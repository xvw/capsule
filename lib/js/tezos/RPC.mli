(** RPC entrypoint description. *)

type error = [ `Json_error of string | `Http_error of int ]

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

(** {1 RPC Directory} *)

val get_balance :
     unit
  -> ( [ `GET ]
     , Z.t
     , Chain_id.t -> Block_id.t -> Contract_id.t -> 'a
     , 'a )
     Entrypoint.t
(** Description of the RPC that get balance for a contract (KT address) or an
    individual (TZ address). *)
