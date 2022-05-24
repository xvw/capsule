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
opam switch create . ocaml-base-compiler.4.14.0 --deps-only -y
eval $(opam env)
```

Once the switch has been initialized, you need to install _the pinned
dependencies_ (at the time of writing this README, **YOCaml is not yet available
on OPAM**, which is very **sad**), by running these commands:

```shellsession
opam install yocaml
opam install yocaml_unix yocaml_yaml yocaml_markdown yocaml_jingoo
```

If everything went well, which I don't doubt for a second, the project should be
compilable and executable, you can now contribute to this blog, for example, to
correct spelling mistakes... For ease of use, I use `make` as a very
_sophisticated orchestrator_. You can run the `make` command to build the binary
that statically serves the site.

## Up and running

- `dune exec bin/capsule.exe -- build [--target=TARGET]` build the website into `TARGET`
- `dune exec bin/capsule.exe -- watch [--target=TARGET] [--port=PORT]` build the website 
  into `TARGET` and serve `TARGET` listening `PORT`.

