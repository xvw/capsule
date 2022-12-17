(** A collection of Arrows to transform Markdown files into HTML, it is very
    similar to [Yocaml_markdown] except that it handles tables of contents. *)

val string_to_html : (string, string) Yocaml.Build.t
val string_to_html_with_toc : (string, string * string) Yocaml.Build.t
