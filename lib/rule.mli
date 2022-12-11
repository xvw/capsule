(** A rule is an action (a YOCaml effect) that produces artefacts in a given
    target. *)

open Yocaml

(** {1 General rules} *)

val static : target:Filepath.t -> unit Effect.t
(** [Rule.static] this is the rule that moves static assets into the target. It
    is equivalent to [Rule.(css >> javascript >> fonts >> images)]. *)

(** {1 Specific rules} *)

val css : target:Filepath.t -> unit Effect.t
(** [Rule.css] this is the rule that moves the CSS files into the target:
    [target/css/]. *)

val javascript : target:Filepath.t -> unit Effect.t
(** [Rule.javascript] this is the rule that moves the JavaScript files into the
    target: [target/js/]. *)

val client : target:Filepath.t -> unit Effect.t
(** [Rule.client] this is the rule that moves the JavaScript client file into
    the target: [target/js/]. *)

val fonts : target:Filepath.t -> unit Effect.t
(** [Rule.fonts] this is the rule that moves the Fonts files into the target:
    [target/fonts]. *)

val images : target:Filepath.t -> unit Effect.t
(** [Rule.images] this is the rule that moves the images files into the target:
    [target/images]. *)

(** {1 Static rules} *)

val pages : target:Filepath.t -> unit Effect.t
(** [Rule.pages] this is the rule that produces static pages. *)

val indexes : target:Filepath.t -> unit Effect.t
(** [Rule.indexes] this is the rule that produces static indexes. *)

val addresses : target:Filepath.t -> unit Effect.t
(** [Rule.indexes] this is the rule that produces static addresses. *)

val dapps : target:Filepath.t -> unit Effect.t
(** [Rule.indexes] this is the rule that produces static page as a DApp vessel. *)
