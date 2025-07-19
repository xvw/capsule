let version = "dev"
let exits = Cmdliner.Cmd.Exit.defaults

let bug_report =
  "The application's source code is published on \
   <https://github.com/xvw/capsule>. Feel free to contribute or report bugs \
   via <https://github.com/xvw/capsule/issues>."
;;

let description =
  "Website generator <https://xvw.lol>. Xavier Van de Woestyne's personal \
   website, acting as a personal blog, and built, in OCaml \
   (<https://ocaml.org>) with the YOCaml framework \
   (<https://github.com/xhtmlboi/yocaml>)."
;;

let man =
  Cmdliner.
    [ `S Manpage.s_description
    ; `P description
    ; `S Manpage.s_bugs
    ; `P bug_report
    ]
;;

let with_message source target f () =
  let open Yocaml.Eff in
  let* () =
    logf
      ~level:`Info
      "Trigger [%a] in [%a]"
      Yocaml.Path.pp
      source
      Yocaml.Path.pp
      target
  in
  f ()
;;

let name_from_file file =
  file
  |> Filename.basename
  |> Filename.remove_extension
  |> String.map (function
    | ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9') as c -> c
    | _ -> '_')
;;

let run_pp_syntax file =
  let json = Yojson.Basic.from_file file in
  let yojs = Yojson.Basic.show json in
  let binding = "\nlet " ^ name_from_file file ^ " = \n" in
  print_endline (binding ^ yojs)
;;

let run_build log_level target source configuration_file =
  let module Resolver =
    Generator.Resolver.Make (struct
      let source, target = source, target
      let configuration_file = configuration_file
    end)
  in
  let program =
    with_message source target
    @@ Generator.Action.run (module Resolver : Generator.Intf.RESOLVER)
  in
  let () = Yocaml_runtime.Log.setup ~level:log_level () in
  Yocaml_eio.run ~level:log_level program
;;

let run_watch port log_level target source configuration_file =
  let module Resolver =
    Generator.Resolver.Make (struct
      let source, target = source, target
      let configuration_file = configuration_file
    end)
  in
  let program =
    with_message source target
    @@ Generator.Action.run (module Resolver : Generator.Intf.RESOLVER)
  in
  let () = Yocaml_runtime.Log.setup ~level:log_level () in
  Yocaml_eio.serve ~level:log_level ~target ~port program
;;

let build =
  let doc =
    "Builds the site in the directory referenced by TARGET, based on the \
     directory referenced by SOURCE, using a configuration file and tracing \
     actions with the given log level."
  in
  let info = Cmdliner.Cmd.info "build" ~version ~doc ~exits ~man in
  let term =
    Cmdliner.Term.(
      const run_build
      $ Arg.log_level ~default:`Debug ()
      $ Arg.target ()
      $ Arg.source ()
      $ Arg.config_file ())
  in
  Cmdliner.Cmd.v info term
;;

let watch =
  let doc =
    "Launch a development server on the given PORT and Builds continuously the \
     site in the directory referenced by TARGET, based on the directory \
     referenced by SOURCE, using a configuration file and tracing actions with \
     the given log level."
  in
  let info = Cmdliner.Cmd.info "watch" ~version ~doc ~exits ~man in
  let term =
    Cmdliner.Term.(
      const run_watch
      $ Arg.port ()
      $ Arg.log_level ~default:`Info ()
      $ Arg.target ()
      $ Arg.source ()
      $ Arg.config_file ())
  in
  Cmdliner.Cmd.v info term
;;

let pp_syntax =
  let doc = "Run a pretty-printer on a given syntax in JSON." in
  let info = Cmdliner.Cmd.info "pp-syntax" ~version ~doc ~exits ~man in
  let file =
    Cmdliner.Arg.(
      required
        (pos
           0
           (some non_dir_file)
           None
           (info [] ~docv:"FILE" ~doc:"A syntax to be pretty printed")))
  in
  let term = Cmdliner.Term.(const run_pp_syntax $ file) in
  Cmdliner.Cmd.v info term
;;

let index =
  let doc = "xvw.lol" in
  let info =
    Cmdliner.Cmd.info "dune exec bin/capsule.exe --" ~version ~doc ~man
  in
  let default = Cmdliner.Term.(ret (const (`Help (`Pager, None)))) in
  Cmdliner.Cmd.group info ~default [ build; watch; pp_syntax ]
;;
