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
  (js_of_ocaml  (>= 5.6.0))
  (js_of_ocaml-compiler (= 5.7.1))
  (js_of_ocaml-ppx  (= 5.7.1))
  (js_of_ocaml-lwt  (= 5.7.1))
  (mdx (and :with-test (>= 2.0.0)))
  vdom
  data-encoding
  tezos-base58
  preface
  yocaml
  yocaml_unix
  yocaml_yaml
  yocaml_jingoo
  yocaml_syndication
  nightmare
  nightmare-tyxml
  nightmare_js
  nightmare_js-vdom
  yourbones
  yourbones-ppx
  (yourbones_js :pinned)
  (yourbones_js-beacon :pinned)

  ;; Dev setup
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (utop :with-dev-setup)))
