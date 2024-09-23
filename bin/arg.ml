let docs = Cmdliner.Manpage.s_common_options

let target ?(default = Yocaml.Path.rel [ "_www" ]) () =
  let doc = "Target directory" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "target"; "output" ] in
  Cmdliner.Arg.(value @@ opt Conv.path default arg)
;;

let source ?(default = Yocaml.Path.rel []) () =
  let doc = "Source directory" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "source"; "input" ] in
  Cmdliner.Arg.(value @@ opt Conv.path default arg)
;;

let port ?(default = 8888) () =
  let doc = "The development server's listening port" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "port"; "P" ] in
  Cmdliner.Arg.(value @@ opt Conv.port default arg)
;;

let log_level ?(default = `App) () =
  let doc = "The log-level of the application running" in
  let arg = Cmdliner.Arg.info ~doc ~docs [ "log-level"; "level"; "log" ] in
  Cmdliner.Arg.(value @@ opt Conv.log_level default arg)
;;
