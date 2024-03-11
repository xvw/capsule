# capsule

> A rather clumsy attempt to have a static blog generator (based on
> [YOCaml](https://github.com/xhtmlboi/yocaml)) that puts less pressure on me to
> write long articles that nobody reads.

## Local installation

The most standard way to start a development environment is to build a "_local
switch_" by sequentially running these different commands (which assume that
[OPAM](https://opam.ocaml.org/) is installed on your machine).

```shellsession
opam update
opam switch create . ocaml.5.1.1 --deps-only -y --with-dev-setup --with-test
opam install yourbones_js yourbones_js-beacon
eval $(opam env)
```

And since the JavaScript part of the application relay on ... `npm`, you have to
install `npm` and running `make` will build the inner library... `hell.js`.

If everything went well, which I don't doubt for a second, the project should be
compilable and executable, you can now contribute to this blog, for example, to
correct spelling mistakes... For ease of use, I use `make` as a very
_sophisticated orchestrator_. You can run the `make` command to build the binary
that statically serves the site.

## Up and running

- `dune exec bin/capsule.exe -- build [--target=TARGET]` build the website into `TARGET`
- `dune exec bin/capsule.exe -- watch [--target=TARGET] [--port=PORT]` build the website
  into `TARGET` and serve `TARGET` listening `PORT`.
