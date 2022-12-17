(** Set of data structures that can be manipulated in the generator. *)

open Yocaml

(** Represents a K/V entry in order to add flexible metadata to a field*)
module KVMap : sig
  type t
end

(** Several types of documents can be attached to links. [Link] describes a
    simple link. A link is characterized by:

    - a [name]: which is the name of the link, for example: [OCaml website]
    - a [href]: which is the target of the mail. for examle: [https://ocaml.org]
    - an optional [title]: which is mandatory for accessibility purpose.
    - an optional [description]: for giving some context to the link.*)
module Link : sig
  type t
end

(** An index is a [name] with a [synopsis] and a collection of [links]. *)
module Index : sig
  type t
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
