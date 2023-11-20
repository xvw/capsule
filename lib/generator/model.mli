(** Set of data structures that can be manipulated in the generator. *)

open Yocaml

module Date_filename : sig
  val from_filename : Filepath.t -> (string * Date.t) Validate.t
  val from_filename_opt : Filepath.t -> (string * Date.t) option
end

(** A page is the atom of the application. The only relationship it has with the
    rest of the elements is built via the breadcrumb. *)
module Page : sig
  type t

  val map_synopsis : (string, string) Build.t -> (t, t) Build.t
  val inject_toc : (t * (string * string), t * string) Build.t

  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t
end

(** Represents a model attached to a page. *)
module type WITH_PAGE = sig
  type t

  val map_synopsis : (string, string) Build.t -> (t, t) Build.t
end

(** Represents an entry into the journal. *)
module Entry : sig
  type t

  include WITH_PAGE with type t := t
  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t
end

(** Represents a page of journal. *)
module Entries : sig
  type t

  include Metadata.INJECTABLE with type t := t

  val get_entries :
    Filepath.t -> int -> (int * (Date.t * string) list list) Effect.t

  val read_entries :
       (module Metadata.VALIDABLE)
    -> int
    -> int
    -> (string, string) Build.t
    -> (Date.t * string) list
    -> (Page.t * string, t * string) Build.t

  val preapply_for_one : (t * string, t * string) Build.t
end

(** An address is a page with additional metadata related to a gallery. *)
module Gallery : sig
  type t

  include WITH_PAGE with type t := t
  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t
end

(** An address is a page with additional metadata related to an address. *)
module Address : sig
  type t

  include WITH_PAGE with type t := t
  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t
end

(** A Dapp is a page with additional metadata related to a DApp manifest. *)
module Dapp : sig
  type t

  include WITH_PAGE with type t := t
  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t

  val join_files : (string * (t * string), t * string) Build.t
  val map_manifest : (string, string) Build.t -> (t, t) Build.t
end

(** Deal with Atom Feeds *)
module Feed : sig
  val pages :
       (module Metadata.VALIDABLE)
    -> feed_file:Filepath.t
    -> Filepath.t
    -> int
    -> (unit, string) Build.t t

  val addresses :
       (module Metadata.VALIDABLE)
    -> feed_file:Filepath.t
    -> Filepath.t
    -> int
    -> (unit, string) Build.t t

  val journal :
       (module Metadata.VALIDABLE)
    -> feed_file:Filepath.t
    -> Filepath.t
    -> int
    -> (unit, string) Build.t t

  val all :
       (module Metadata.VALIDABLE)
    -> feed_file:Filepath.t
    -> path_pages:Filepath.t
    -> path_addresses:Filepath.t
    -> path_journal:Filepath.t
    -> int
    -> (unit, string) Build.t t
end
