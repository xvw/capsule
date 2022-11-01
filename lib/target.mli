(** Define some helpers for defining target. *)

open Yocaml

val capsule : target:Filepath.t -> Filepath.t
(** The root of the project. *)

(** {1 Subfolders for artifacts}

    These functions only return paths to subdirectories of the target. *)

val css : target:Filepath.t -> Filepath.t
(** [Target.css ~target] is the subfolder that contains CSS files. *)

val javascript : target:Filepath.t -> Filepath.t
(** [Target.javascript ~target] is the subfolder that contains JavaScript files. *)

val fonts : target:Filepath.t -> Filepath.t
(** [Target.fonts ~target] is the subfolder that contains Fonts files. *)

val images : target:Filepath.t -> Filepath.t
(** [Target.images ~target] is the subfolder that contains images files. *)

val pages : target:Filepath.t -> Filepath.t
(** [Target.pages ~target] is the subfolder that contains pages files. *)

val indexes : target:Filepath.t -> Filepath.t
(** [Target.indexes ~target] is the subfolder that contains indexes files. *)

(** {1 Direct target for artifact}

    These functions give the target path for a specific file. *)

val for_page : target:Filepath.t -> string -> Filepath.t
(** [Target.for_page ~target "a_page.md"] will returns the path of the page
    (with the extension changed in favor of [.html]). *)

val for_index : target:Filepath.t -> string -> Filepath.t
(** [Target.for_index ~target "a_page.md"] will returns the path of the index
    (with the extension changed in favor of [.html]). *)
