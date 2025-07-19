# Credits

Lists the resources used to build this website. This page will be used
to supply the colophon page.

## Typography

- [Inria Serif](https://black-foundry.com/case-studies/inria-identity-font/)
- [Fira Code](https://github.com/tonsky/FiraCode)
- [Libre Franklin](https://github.com/impallari/Libre-Franklin?tab=readme-ov-file)

## Iconography

- [Simple Icons](https://simpleicons.org/)
- [Creative Commons Icons](https://creativecommons.org/mission/downloads/)

## Generator

The site is built using the [YOCaml static blog
generator](https://github.com/xhtmlboi/yocaml) and the following
plugins (the dependencies of each package are listed on the package
description pages):

- [yocaml](https://ocaml.org/p/yocaml/latest) and
  [yocaml_runtime](https://ocaml.org/p/yocaml_runtime/latest)
- [yocaml_eio](https://ocaml.org/p/yocaml_eio/latest) (based on
  [eio](https://ocaml.org/p/eio/latest) and
  [cohttp](https://ocaml.org/p/cohttp-eio/latest))
- [yocaml_cmarkit](https://ocaml.org/p/yocaml_cmarkit/latest) (based
  on [cmarkit](https://ocaml.org/p/cmarkit/latest))
- [yocaml_jingoo](https://ocaml.org/p/yocaml_jingoo/latest) (based on
  [jingoo](https://ocaml.org/p/jingoo/latest))
- [yocaml_syndication](https://ocaml.org/p/yocaml_syndication/latest)
- [yocaml_otoml](https://ocaml.org/p/yocaml_otoml/latest) (based on
  [otoml](https://ocaml.org/p/otoml/latest))

### Syntax Highlighting

For the syntax highlighting, I use the [Hilite
package](https://ocaml.org/p/hilite/latest) and the default [set
bundled](https://github.com/patricoferris/hilite/tree/main/src/syntaxes)
by the library. I have specific syntax retreived from:
- Haskell
  [Haskell.tmBundle](https://github.com/textmate/haskell.tmbundle/blob/master/Syntaxes/Haskell.plist)
- Java [Java.tmBundle](https://github.com/textmate/java.tmbundle/blob/master/Syntaxes/Java.plist)
- Kotlin [Kotlin.tmBundle](https://github.com/vkostyukov/kotlin-sublime-package/blob/master/Kotlin.tmLanguage)
- Lisp [Lisp.tmBundle](https://github.com/textmate/lisp.tmbundle/blob/master/Syntaxes/Lisp.plist)


In addition, [OCaml](https://ocaml.org), [Dune](https://dune.build),
[ppx_expect](https://ocaml.org/p/ppx_expect/latest) and
[mdx](https://ocaml.org/p/mdx/latest),
[cmdliner](https://ocaml.org/p/cmdliner/latest) are used. Please refer
to the project description ([dune-project](dune-project)).
