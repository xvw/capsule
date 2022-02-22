.PHONY: all clean

all:
	dune build

clean:
	dune clean

lint:
	dune build @fmt --auto-promote

check-lint:
	dune build @fmt
