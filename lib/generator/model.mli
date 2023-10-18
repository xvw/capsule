(** Set of data structures that can be manipulated in the generator. *)

open Yocaml

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
