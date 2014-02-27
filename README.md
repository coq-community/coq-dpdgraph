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

        Print FileDependGraph <module name list>.

    A module can be a file, or a sub-module in a file.
    Example :  

        Print FileDependGraph M M2.A.B.

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

#### From a .dpd file to a .dot file

```
$ ./dpd2dot graph.dpd
Info: read file graph.dpd
Info: Graph output in graph.dot
```

There are some options :
```
$ ./dpd2dot -help
Usage : ./dpd2dot [options]
  -o : name of output file (default: name of input file .dot)
  -with-defs : show everything (default)
  -without-defs : show only Prop objects
  -rm-trans : remove transitive dependencies (default)
  -keep-trans : keep transitive dependencies
  -debug : set debug mode
  -help  Display this list of options
  --help  Display this list of options
```

The only useful option at the moment is ``-without-defs`` that export only
``Prop`` objects to the graph (``Axiom``, ``Theorem``, ``Lemma``, etc).

#### Graph visualisation

You need :

- [graphviz](http://www.graphviz.org/) (ie. dot tool)
- a visualizer:
  I personally use [zgrviewer](http://zvtm.sourceforge.net/zgrviewer.html)
  but there are others.

You can also convert .dot file to .svg file using :
```
$ dot -Tsvg file.dot > file.svg
```
You can then use ``firefox`` or ``inskape`` to view the ``.svg`` graph.

The main advantage of using ``firefox`` is that the nodes are linked to
the ``coqdoc`` pages if they have been generated in the same directory.
But the navigation (zoom, moves) is very poor and slow.

#### Graph interpretation

The graph can be interpreted like this :
- edge n1 --> n2 : n1 uses n2
- node :
  - green : proved lemma
  - orange :  axiom/admitted lemma
  - dark pink : Definition, etc
  - light pink : Parameter, etc
  - violet : inductive,
  - blue : constructor,
  - multi-circled : not used (no predecessor in the graph)
- yellow box : module
- objects that are not in a yellow box are COQ objects.

## Development information

#### Generated ``.dpd`` format description

```
graph : obj_list
obj : node | edge

node : "N: " node_id node_name '[' node_attribute_list ']' ';'
node_id : [0-9]+
node_name : '"' string '"'
node_attribute_list :
   | empty
   | node_attribute ',' node_attribute_list
node_attribute :
   | kind=[cnst|inductive|construct]
   | prop=[yes|no]
   | path="m0.m1.m2"
   | body=[yes|no]

edge : "E: "  node_id node_id '[' edge_attribute_list ']' ';'
edge_attribute_list :
   | empty
   | edge_attribute ',' edge_attribute_list
edge_attribute :
   | weight=NUM
```

The parser accept .dpd files as described above,
  but also any attribute for nodes and edges having the form :
  ``prop=val`` or ``prop="string..."`` or ``prop=NUM``
  so that the generated ``.dpd`` can have new attributes without having to change
  the other tools.
  Each tool can then pick the attributes that it is able to handle;
  they are not supposed to raise an error whenever there is
  an unknown attribute.


## More information

Also see the files:
- TODO 
- [CHANGES](CHANGES)
