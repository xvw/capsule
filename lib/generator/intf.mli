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
    val js : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val images : Yocaml.Path.t
    val diagrams : Yocaml.Path.t
    val d2 : Yocaml.Path.t
    val maps : Yocaml.Path.t
    val content_images : Yocaml.Path.t
    val indexes : Yocaml.Path.t
    val pages : Yocaml.Path.t
    val addresses : Yocaml.Path.t
    val galleries : Yocaml.Path.t
    val journal_entries : Yocaml.Path.t
    val journal_feed : Yocaml.Path.t
    val template : string -> Yocaml.Path.t
    val talks : Yocaml.Path.t
    val speaking : Yocaml.Path.t
    val books : Yocaml.Path.t
    val readings : Yocaml.Path.t
    val readings_list : Yocaml.Path.t
    val now : Yocaml.Path.t
    val activity : Yocaml.Path.t

    module En : sig
      val index : Yocaml.Path.t
      val articles : Yocaml.Path.t
    end

    module Kohai : sig
      val root : Yocaml.Path.t
      val state : Yocaml.Path.t
      val logs : Yocaml.Path.t
      val last_logs : Yocaml.Path.t
      val log : Kohai_core.Uuid.t -> Yocaml.Path.t
      val sectors : Yocaml.Path.t
      val projects : Yocaml.Path.t
      val state_of : Yocaml.Path.t -> Yocaml.Path.t
      val page_of : Yocaml.Path.t -> Yocaml.Path.t

      module Project : sig
        val list : Yocaml.Path.t
        val state_of : Yocaml.Path.t -> Yocaml.Path.t
        val page_of : Yocaml.Path.t -> Yocaml.Path.t
      end
    end
  end

  module Target : sig
    val root : Yocaml.Path.t
    val promote : Yocaml.Path.t -> Yocaml.Path.t
    val cache : Yocaml.Path.t
    val css : Yocaml.Path.t
    val js : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val images : Yocaml.Path.t
    val pages : Yocaml.Path.t
    val maps : Yocaml.Path.t
    val speaking : Yocaml.Path.t
    val readings : Yocaml.Path.t
    val now : Yocaml.Path.t
    val activity : Yocaml.Path.t
    val projects : Yocaml.Path.t
    val project : Yocaml.Path.t -> Yocaml.Path.t
    val as_html : Yocaml.Path.t -> Yocaml.Path.t
    val as_page : Yocaml.Path.t -> Yocaml.Path.t
    val as_address : Yocaml.Path.t -> Yocaml.Path.t
    val as_gallery : Yocaml.Path.t -> Yocaml.Path.t
    val as_index : Yocaml.Path.t -> Yocaml.Path.t
    val as_diagram : Yocaml.Path.t -> Yocaml.Path.t
    val as_journal_entry : Yocaml.Path.t -> Yocaml.Path.t
    val as_journal_feed_page : int -> Yocaml.Path.t

    module En : sig
      val root : Yocaml.Path.t
      val articles : Yocaml.Path.t
      val as_article : Yocaml.Path.t -> Yocaml.Path.t
    end

    module Atom : sig
      val pages : Yocaml.Path.t
      val general : Yocaml.Path.t
      val addresses : Yocaml.Path.t
      val galleries : Yocaml.Path.t
      val journal : Yocaml.Path.t
      val tag : string -> Yocaml.Path.t

      module En : sig
        val articles : Yocaml.Path.t
        val tag : string -> Yocaml.Path.t
      end
    end
  end
end
