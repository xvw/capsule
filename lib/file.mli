(** Utilities for working with file (names). *)

open Yocaml

(** {1 Predicates}

    Predicate on file names. *)

val is_css : Filepath.t Preface.Predicate.t
val is_javascript : Filepath.t Preface.Predicate.t
val is_markdown : Filepath.t Preface.Predicate.t
val is_image : Filepath.t Preface.Predicate.t
