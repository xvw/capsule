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

dev-deps:
	opam install dune merlin ocamlformat ocp-indent utop -y

local-deps:
	opam install . --deps-only --with-doc --with-test -y

pinned-deps: local-deps
	opam install yocaml yocaml_unix yocaml_yaml yocaml_jingoo yocaml_syndication  -y

deps: pinned-deps dev-deps
