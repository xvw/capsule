(** Describe [Path] for RPC endpoint. This code was widely inspired by
    {{:https://github.com/funkywork/nightmare} Nightmare}. *)

(** {1 Types} *)

type ('continuation, 'witness) t
type 'a fragment

(** {1 Fragments} *)

(** {2 Built-in fragments} *)

val string : string fragment
val int : int fragment
val chain_id : Chain_id.t fragment
val block_id : Block_id.t fragment
val contract_id : Contract_id.t fragment

(** {2 Fragments Helpers} *)

val fragment : string -> ('a -> string) -> 'a fragment

val fragment_module :
  (module Interfaces.PATH_FRAGMENT with type t = 'a) -> 'a fragment

(** {1 Creating path} *)

val root : ('a, 'a) t
val const : ('a, 'b) t -> string -> ('a, 'b) t
val hole : ('a, 'b -> 'c) t -> 'b fragment -> ('a, 'c) t

(** {2 Infix operators} *)

val ( / ) : ('a, 'b) t -> string -> ('a, 'b) t
val ( /: ) : ('a, 'b -> 'c) t -> 'b fragment -> ('a, 'c) t
val ( ~/ ) : string -> ('a, 'a) t
val ( ~/: ) : 'a fragment -> ('a -> 'b, 'b) t
val ( ~: ) : (unit -> 'a) -> 'a

(** {2 Path helpers} *)

val sprintf_with : (string -> 'b) -> ('a, 'b) t -> 'a
val sprintf : ('a, string) t -> 'a
