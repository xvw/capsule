type node_content =
  | Link of string * string
  | Text of string
  | Paragraph of node_content list

val cheat_with_string_document : string -> string
val parse_mastodon_response : string -> node_content list
