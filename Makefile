.PHONY: all clean lint clean check-lint utop hell

all: hell
	dune build

clean:
	dune clean

lint:
	dune build @fmt --auto-promote

check-lint:
	dune build @fmt

utop:
	dune utop lib

hell:
	(cd hell; npm install; npm run build)
