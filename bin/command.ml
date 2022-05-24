open Cmdliner

let docs = Manpage.s_common_options
let exits = Cmd.Exit.defaults
let version = "dev"

let target_args =
  let doc =
    Fmt.str "The directory in which to build the website. (default value: [%s])"
      Default.target
  in
  let arg = Arg.info ~doc ~docs [ "target"; "output"; "www" ] in
  Arg.(value (opt file Default.target arg))

let port_args =
  let doc =
    Fmt.str
      "Defines the port on which the server should listen. (default value: \
       [%d])"
      Default.port
  in
  let arg = Arg.info ~doc ~docs [ "port"; "P" ] in
  Arg.(value (opt int Default.port arg))

let build =
  let doc = "Builds the website" in
  let info = Cmd.info "build" ~version ~doc ~exits in
  let term = Term.(const Action.build $ target_args) in
  Cmd.v info term

let watch =
  let doc =
    "Serve the [target] directory as an HTTP server and rebuild website on \
     each request"
  in
  let info = Cmd.info "watch" ~version ~doc ~exits in
  let term = Term.(const Action.watch $ target_args $ port_args) in
  Cmd.v info term

let index =
  let doc = "Capsule" in
  let info = Cmd.info Sys.argv.(0) ~version ~doc ~sdocs:docs ~exits in
  let default = Term.(ret (const (`Help (`Pager, None)))) in
  Cmd.group info ~default [ build; watch ]
