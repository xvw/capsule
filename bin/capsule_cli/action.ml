open Yocaml

let program target =
  let* () = Generator.Rule.static ~target in
  let* () = Generator.Rule.indexes ~target in
  let* () = Generator.Rule.pages ~target in
  let* () = Generator.Rule.addresses ~target in
  let* () = Generator.Rule.journal ~target ~size:4 in
  let* () = Generator.Rule.journal_feed ~target ~size:25 in
  let* () = Generator.Rule.dapps ~target in
  return ()

let build target = Yocaml_unix.execute $ program target

let watch target port =
  let server = Yocaml_unix.serve ~filepath:target ~port $ program target in
  let () = build target in
  Lwt_main.run server

let template =
  {|---
tags:
  - tag1
  - tag2
meta:
  - key: key A
    value: value A
indexes:
  - name: An Index
    synopsis: Synopsis de l'index
    links:
      - name: Google
        href: https://www.google.com
---

content|}

let gen_entry () =
  let mtime = Unix.(() |> time |> localtime) in
  let fname =
    Format.asprintf "content/journal/%04d-%02d-%02d_%02d-%02d-%02d.md"
      (1900 + mtime.Unix.tm_year)
      (1 + mtime.Unix.tm_mon) mtime.Unix.tm_mday mtime.Unix.tm_hour
      mtime.Unix.tm_min mtime.Unix.tm_sec
  in
  match Yocaml_unix.write_file fname template with
  | Ok () -> Printf.printf "[%s] has been created\n" fname
  | Error err ->
      let message = Format.asprintf "%a" Error.pp err in
      failwith message
