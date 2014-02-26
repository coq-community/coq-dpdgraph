# coq-dpdgraph

Build dependency graphs between COQ objects,
where COQ is the famous formal proof management system (see
http://coq.inria.fr/).

**Coming soon !**

## What's inside ?

First of all, it is a small tool (an extended COQ toplevel) that extracts the
dependencies between COQ objects, and produce a file (.dpd) with this 
information.

Then, another tool reads these .dpd files and produce graph file
using .dot format (cf. http://www.graphviz.org/) that makes possible to view
them.

The idea is that other small tools can be developed latter on to process
the .dpd files.

## Compilation

#### Requirements

- to be able to build a coqtop (I don't know exactly what is needed...)
   (at least ocaml, calmp5, libcoq-ocaml-dev, ... ?)
  The last version has been tested with:
  - Coq 8.4pl2 (January 2014)
  - compiled with OCaml 4.00.1
- [ocamlgraph](http://ocamlgraph.lri.fr/) (for dpd2dot tool)
  Any version should work since only the basic feature are used.

#### Compile

    $ make

should produce 2 executables :
- ./coqthmdep : an extended coqtop to be able to build .dpd files.
- ./dpd2dot : a tool to transform .dpd files into .dot graphs.

#### Test

    $ make -s test

to check if everything is ok.

## How to use it

#### Requirements

- to have compiled the tools (see above)
- a compiled COQ file.
  You can for instance use ``tests/Test.v`` (a modified clone of COQ ``List.v``)
   and compile it doing :
```
  $ coqc tests/Test.v
```


#### Generation of .dpd files

The available commands are :
- Generate dependencies between a list of objects:
```
Print FileDependGraph <module name list>.
```
   A module can be a file, or a sub-module in a file.
   Example :  
```
Print FileDependGraph M M2.A.B.
```
   Take all the objects of the specified modules and build the dependencies
   between them.

- Generate the dependencies of one objects:
```
    Print DependGraph my_lemma.
```
  Analyse recursively the dependencies of ``my_lemma``.

- Change the name of the generated file (default is ``graph.dpd``):
```
    Set DependGraph File "f.dpd".
```
  Useful when one needs to build several files in one session.

**Advice:**
you need to use ``Require`` to load the module that you want to explore,
    but don't use any ``Import``/``Export``
   command because the tool is then unable
    to properly group the nodes by modules.

**Example:**
```
$ ledit ./coqthmdep -I tests/
Welcome to Coq 8.2 (February 2009)
Coq < Require Test.
Coq < Print FileDependGraph Test.
Info: Graph output in graph.dpd
Coq < Set DependGraph File "graph2.dpd".
Coq < Print DependGraph Test.Permutation_app_swap.
Info: Graph output in graph2.dpd
^D
```


