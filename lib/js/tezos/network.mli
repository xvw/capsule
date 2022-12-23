(** Describe a Tezos Network (to a node). *)

type type_ =
  | CUSTOM
  | DELPHINET
  | EDONET
  | FLORENCENET
  | GRANADANET
  | HANGZHOUNET
  | ITHACANET
  | JAKARTANET
  | KATHMANDUNET
  | LIMANET
  | DAILYNET
  | MONDAYNET
  | GHOSTNET
  | MAINNET

type t = { name : string; rpc_url : string; type_ : type_ }

val to_string : type_ -> string
val from_string : string -> type_
val base_path : t -> string

module Nodes : sig
  module Mainnet : sig
    val make : name:string -> rpc_url:string -> t
    val marigold : t
    val ecadlabs : t
    val smartpy : t
    val tezos_foundation : t
    val teztools : t
  end

  module Ghostnet : sig
    val make : name:string -> rpc_url:string -> t
    val marigold : t
  end
end
