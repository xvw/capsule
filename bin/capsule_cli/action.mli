(** Action executable by the [capsule.exe] binary. *)

val build : string -> unit
(** [build target] Action to build the site into [target]. *)

val watch : string -> int -> unit
(** [watch target port] Serves the site in watch-mode in the given [target]
    listening to the given [port]. *)
