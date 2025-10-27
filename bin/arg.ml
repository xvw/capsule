let docs = Cmdliner.Manpage.s_common_options
let yocaml_path = Conv.path
let port = Conv.port
let log_level = Conv.log_level

let target ?(default = Yocaml.Path.rel [ "_www" ]) () =
  let doc = "Target directory" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "target"; "output" ] in
  Cmdliner.Arg.(value @@ opt yocaml_path default arg)
;;

let source ?(default = Yocaml.Path.rel []) () =
  let doc = "Source directory" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "source"; "input" ] in
  Cmdliner.Arg.(value @@ opt yocaml_path default arg)
;;

let port ?(default = 8888) () =
  let doc = "The development server's listening port" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "port"; "P" ] in
  Cmdliner.Arg.(value @@ opt port default arg)
;;

let config_file ?(default = "capsule.toml") () =
  let doc = "The main configuration file (ie: capsule.toml)" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "configuration"; "config"; "C" ] in
  Cmdliner.Arg.(value @@ opt Cmdliner.Arg.file default arg)
;;

let log_level ?(default = `Debug) () =
  let doc = "The log-level of the application running" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "log-level"; "level"; "log" ] in
  Cmdliner.Arg.(value @@ opt log_level default arg)
;;
