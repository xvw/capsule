open Yocaml

let program target =
  let* () = Generator.Rule.static ~target in
  let* () = Generator.Rule.indexes ~target in
  let* () = Generator.Rule.pages ~target in
  let* () = Generator.Rule.addresses ~target in
  let* () = Generator.Rule.dapps ~target in
  return ()

let build target = Yocaml_unix.execute $ program target

let watch target port =
  let server = Yocaml_unix.serve ~filepath:target ~port $ program target in
  let () = build target in
  Lwt_main.run server
