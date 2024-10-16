module type RESOLVABLE = sig
  val configuration_file : string
  val source : Yocaml.Path.t
  val target : Yocaml.Path.t
end

module type RESOLVER = sig
  val track_common_deps : (unit, unit) Yocaml.Task.t

  module Source : sig
    val root : Yocaml.Path.t
    val configuration : Yocaml.Path.t
    val cname : Yocaml.Path.t
    val favicon : Yocaml.Path.t
    val css : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val images : Yocaml.Path.t
    val pages : Yocaml.Path.t
    val template : string -> Yocaml.Path.t
  end

  module Target : sig
    val root : Yocaml.Path.t
    val promote : Yocaml.Path.t -> Yocaml.Path.t
    val cache : Yocaml.Path.t
    val css : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val images : Yocaml.Path.t
    val pages : Yocaml.Path.t
    val as_html : Yocaml.Path.t -> Yocaml.Path.t
    val as_page : Yocaml.Path.t -> Yocaml.Path.t
  end
end
