(lang dune 3.2)
(name capsule)
(version dev)
(generate_opam_files true)

(source (github xvw/capsule))
(license MIT)
(authors "Xavier Van de Woestyne")
(maintainers "Xavier Van de Woestyne")

(package
 (name capsule)
 (synopsis "Microblogging for fun an profit")
 (description "The source code for my website [xvw.lol]")
 (allow_empty)
 (depends
  (ocaml (>= 5.0.0))
  (dune (>= 3.8.0))
  (logs (>= 0.7.0))
  (cmdliner (>= 1.0.0))
  (omd (>= 2.0.0~alpha2))
  (js_of_ocaml-compiler (>= 5.2.0))
  (js_of_ocaml-ppx (>= 5.2.0))
  (js_of_ocaml-lwt (>= 5.2.0))
  promise_jsoo
  ocaml-vdom
  data-encoding
  tezos-base58
  preface
  (yocaml :pinned)
  (yocaml_unix :pinned)
  (yocaml_yaml :pinned)
  (yocaml_jingoo :pinned)))
