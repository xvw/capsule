val target : ?default:Yocaml.Path.t -> unit -> Yocaml.Path.t Cmdliner.Term.t
val source : ?default:Yocaml.Path.t -> unit -> Yocaml.Path.t Cmdliner.Term.t
val port : ?default:int -> unit -> int Cmdliner.Term.t

val log_level
  :  ?default:([ `App | `Info | `Error | `Warning | `Debug ] as 'loglevel)
  -> unit
  -> 'loglevel Cmdliner.Term.t
