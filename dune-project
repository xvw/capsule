(lang dune 3.10)
(name capsule)
(version dev)
(generate_opam_files true)
(using mdx 0.4)

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
  (mdx (and :with-test (>= 2.0.0)))
  promise_jsoo
  vdom
  data-encoding
  tezos-base58
  preface
  (yocaml :pinned)
  (yocaml_unix :pinned)
  (yocaml_yaml :pinned)
  (yocaml_jingoo :pinned)
  (yocaml_syndication :pinned)
  (nightmare :pinned)
  (nightmare-dream :pinned)
  (nightmare-tyxml :pinned)
  (nightmare_js :pinned)
  (nightmare_js-vdom :pinned)
  (yourbones :pinned)
  (yourbones-ppx :pinned)
  (yourbones_js :pinned)
  (yourbones_js-beacon :pinned)

  ;; Dev setup
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (utop :with-dev-setup)))
