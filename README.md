## MirageOS tuturial

A basic notion of OCaml is assumed, but please ask questions.

### OCaml Setup

You need `OCaml` 4.01 or 4.02 and `opam` (version 1.2.2 if
possible). These should be available on your favorite
package manager.

Installing and using `merlin` and `ocp-indent` is strongly
encouraged.

### Install Mirage

You will need the latest version of MirageOS (not yet released). To
install it run:

```
make depends
eval `opam config env`
````

This will create a new opam switch in opam and will  install the
development versions of functoria and mirage.

### Testing MirageOS

You can clone `mirage-skeleton` and compiles one of the example to see
if everything is working properly:

```
# git clone -b mirage-dev https://github.com/mirage/mirage-skeleton.git
# cd mirage-skeleton/hello
# mirage configure
# make
# ./main.native
Hello World!
Hello World!
```

## Tutorial

The goal of that tutorial is to write a unikernel proxy that you can
program by punching ports. We will start by doing normal OCaml code
first to warm-up and you will see how to turn that into a (useful?)
unikernel later on.

Start by [Exercice 1](./exo-1/README.md).
