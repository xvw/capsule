(lang dune 3.16)
(name capsule)
(version dev)
(generate_opam_files)
(using mdx 0.4)
(executables_implicit_empty_intf)

(source (github xvw/capsule))
(license GPL-3.0-or-later)
(authors "Xavier Van de Woestyne <xaviervdw@gmail.com>")
(maintainers "Xavier Van de Woestyne <xaviervdw@gmail.com>")

(package
 (name capsule)
 (synopsis "Site generator of https://xvw.lol")
 (description "Source code of the generator of my website")
 (depends

  ;; Build dependencies 
  (ocaml (>= 5.2.0))
  (dune (>= 3.16.0))

   ;; Binary dependencies
   cmdliner
   fmt

  ;; Yocaml dependencies 
  (yocaml (>= 2.0.0))
  (yocaml_eio (>= 2.0.0))
  (yocaml_cmarkit (>= 2.0.0))
  (yocaml_jingoo (>= 2.0.0))
  (yocaml_syndication (>= 2.0.0))
  (yocaml_yaml (>= 2.0.0))
  (yocaml_otoml (>= 2.0.0))
  (yocaml_runtime (>= 2.0.0))

  ;; Nightmare dependencies
  nightmare
  nightmare-tyxml
  nightmare_js
  nightmare_js-vdom

  ;; Generator dependencies
  cmarkit
 
  mdx ;; maybe because I probably want to use `mdx` in some articles

  ;; Test utils
  ppx_expect
   
  ;; Dev setup
  (utop :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
