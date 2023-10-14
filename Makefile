.PHONY: all clean lint clean check-lint utop hell test

all: hell
	dune build

clean:
	dune clean

test:
	dune runtest --no-buffer -j 1

lint:
	dune build @fmt --auto-promote

check-lint:
	dune build @fmt

utop:
	dune utop lib

hell:
	(cd hell; npm install; npm run build)


local-deps:
	opam install . --deps-only --with-doc --with-test --with-dev-setup -y

pinned-deps: local-deps
	opam install yocaml yocaml_unix yocaml_yaml yocaml_jingoo yocaml_syndication  -y
	opam install nightmare nightmare-dream nightmare-tyxml -y
	opam install nightmare_js nightmare_js-vdom -y
	opam install yourbones yourbones-ppx yourbones_js yourbones_js-beacon -y

deps: pinned-deps
