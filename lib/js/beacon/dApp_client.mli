type t

val make :
     ?icon_url:string
  -> ?app_url:string
  -> ?matrix_nodes:string list
  -> ?preferred_network:Network_type.t
  -> name:string
  -> unit
  -> t

val request_permissions :
     ?network:Network.t
  -> ?scopes:Permission_scope.t list
  -> t
  -> Permission_response_output.t Lwt.t

val get_active_account : t -> Account_info.t option Lwt.t
val clear_active_account : t -> unit Lwt.t
val disconnect_wallet : t -> unit Lwt.t
val get_block_explorer : t -> Block_explorer.t
