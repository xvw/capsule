(lang dune 3.16)
(name capsule)
(version dev)
(generate_opam_files)
(using mdx 0.4)
(executables_implicit_empty_intf)

(source (github xvw/capsule))
(license MIT)
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

  ;; Yocaml dependencies 
   yocaml
   yocaml_eio
   yocaml_cmarkit
   yocaml_jingoo
   yocaml_syndication
   yocaml_yaml
   yocaml_otoml
   mdx ;; maybe because I probably want to use `mdx` in some articles

  ;; Test utils
  (ppx_expect :with-test)
   
  ;; Dev setup
  (utop :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
