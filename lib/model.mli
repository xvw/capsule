(** Set of data structures that can be manipulated in the generator. *)

open Yocaml

(** Several types of documents can be attached to links. [Link] describes a
    simple link. A link is characterized by:

    - a [name]: which is the name of the link, for example: [OCaml website]
    - a [href]: which is the target of the mail. for examle: [https://ocaml.org]
    - an optional [title]: which is mandatory for accessibility purpose.
    - an optional [description]: for giving some context to the link.*)
module Link : sig
  type t
end

(** A page is the atom of the application. The only relationship it has with the
    rest of the elements is built via the breadcrumb. *)
module Page : sig
  type t

  include Metadata.READABLE with type t := t
  include Metadata.INJECTABLE with type t := t
end
