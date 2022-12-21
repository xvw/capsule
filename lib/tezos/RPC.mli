(** RPC entrypoint description. *)

val get_balance :
     unit
  -> ( [ `GET ]
     , Z.t
     , Chain_id.t -> Block_id.t -> Contract_id.t -> 'a
     , 'a )
     Entrypoint.t
(** Description of the RPC that get balance for a contract (KT address) or an
    individual (TZ address). *)
