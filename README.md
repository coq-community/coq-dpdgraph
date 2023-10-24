<!---
This file was generated from `meta.yml`, please do not edit manually.
Follow the instructions on https://github.com/coq-community/templates to regenerate.
--->
# coq-dpdgraph

[![Docker CI][docker-action-shield]][docker-action-link]
[![Contributing][contributing-shield]][contributing-link]
[![Code of Conduct][conduct-shield]][conduct-link]
[![Zulip][zulip-shield]][zulip-link]

[docker-action-shield]: https://github.com/coq-community/coq-dpdgraph/workflows/Docker%20CI/badge.svg?branch=coq-v8.18
[docker-action-link]: https://github.com/coq-community/coq-dpdgraph/actions?query=workflow:"Docker%20CI"

[contributing-shield]: https://img.shields.io/badge/contributions-welcome-%23f7931e.svg
[contributing-link]: https://github.com/coq-community/manifesto/blob/master/CONTRIBUTING.md

[conduct-shield]: https://img.shields.io/badge/%E2%9D%A4-code%20of%20conduct-%23f15a24.svg
[conduct-link]: https://github.com/coq-community/manifesto/blob/master/CODE_OF_CONDUCT.md

[zulip-shield]: https://img.shields.io/badge/chat-on%20zulip-%23c1272d.svg
[zulip-link]: https://coq.zulipchat.com/#narrow/stream/237663-coq-community-devs.20.26.20users



Coq plugin that extracts the dependencies between Coq objects,
and produces files with dependency information. Includes tools
to visualize dependency graphs and find unused definitions.

## Meta

- Author(s):
  - Anne Pacalet
  - Yves Bertot
  - Olivier Pons
- Coq-community maintainer(s):
  - Anne Pacalet ([**@Karmaki**](https://github.com/Karmaki))
  - Yves Bertot ([**@ybertot**](https://github.com/ybertot))
- License: [GNU Lesser General Public License v2.1](LICENSE)
- Compatible Coq versions: 8.18 (use the corresponding branch or release for other Coq versions)
- Compatible OCaml versions: 4.05.0 or later
- Additional dependencies:
  - autoconf (except for releases)
  - [OCamlgraph](https://github.com/backtracking/ocamlgraph)
- Coq namespace: `dpdgraph`
- Related publication(s): none

## What's inside?

First of all, it is a small tool (a Coq plugin) that extracts the
dependencies between Coq objects, and produces a file (we suggest using
the suffix .dpd) with this information.

The idea is that other small tools can be then developed to process
the .dpd files. At the moment, there is:
- `dpd2dot` that reads these .dpd files and produces a graph file
using .dot format (cf. http://www.graphviz.org/) that makes possible to view
them;
- `dpdusage`: to find unused definitions.

Hope other tools later on to do more things. Feel free to contribute!

## How to get it

You can:
- either clone it from GitHub at: https://github.com/coq-community/coq-dpdgraph
- or get the opam package named `coq-dpdgraph` from the opam-coq archive (repository "released")
- or get the [latest distributed version](https://github.com/coq-community/coq-dpdgraph/releases)

### Compilation

First download the archive and unpack it (or clone the repository),
and change directory to the `coq-dpdgraph` directory.

Depending on how you got hold of the directory, you may be in one of three situations:

 1/ Makefile is present

   You should type the following command.

    $ make && make install

 2/ configure is present, but no Makefile

   You should type the following command.

    $ ./configure && make && make install

 3/ configure is not present, Makefile is not present

   You should type the following command.

    $ autoconf
    $ configure && make && make install

By default, compilation will fail if there is any warning emitted by
the ocaml compiler.  This can be disabled by type

    make WARN_ERR=

instead of `make` in all previous commands.

### Install using opam

If you use opam, you can install `coq-dpdgraph` and `ocamlgraph` using

    $ opam repo add coq-released https://coq.inria.fr/opam/released
    $ opam install coq-dpdgraph

### Test

If you install the archive by cloning the git repository, you have
a sub-directory containing test files.  These can be tested using the
following command.

    $ make -s test

to check if everything is ok.

## How to use it

### Requirements

- to have compiled the tools (see above)
- a compiled Coq file.
  You can for instance use `tests/Test.v` (a modified clone of Coq `List.v`)
  and compile it doing :
```shell
  $ coqc tests/Test.v
```
  
### Generation of .dpd files

The available commands are :
- Generate dependencies between a list of objects:

        Print FileDependGraph <module name list>.

    A module can be a file, or a sub-module in a file.
    Example :

        Print FileDependGraph M M2.A.B.

    Take all the objects of the specified modules and build the dependencies
    between them.

- Generate the dependencies of one objects:

        Print DependGraph my_lemma.

  Analyse recursively the dependencies of ``my_lemma``.

- Change the name of the generated file (default is ``graph.dpd``):

        Set DependGraph File "f.dpd".

  Useful when one needs to build several files in one session.

**Advice:**
you need to use ``Require`` to load the module that you want to explore,
    but don't use any ``Import``/``Export``
   command because the tool is then unable
    to properly group the nodes by modules.

**Example:**
```
$ ledit coqtop -R . dpdgraph -I tests/
Welcome to Coq 8.5 (April 2016)

Coq < Require dpdgraph.dpdgraph.
[Loading ML file dpdgraph.cmxs ... done]

Coq < Require List.
Coq < Print FileDependGraph List.
Print FileDependGraph List.
Fetching opaque proofs from disk for Coq.Lists.List
Info: output dependencies in file graph.dpd
Coq < Set DependGraph File "graph2.dpd".
^D
```

### dpd2dot: from a .dpd file to a .dot file

#### Graph generation

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
If the name of the output file finishes with ``.dot``, then the name before
the ``.dot`` suffix is used as the graph name in the dot syntax.  There
are two exceptions: ``graph`` and ``digraph`` will be replaced with
``escaped_graph`` and ``escaped_digraph`` respectively.

The only useful option at the moment is ``-without-defs`` that export only
``Prop`` objects to the graph (``Axiom``, ``Theorem``, ``Lemma``, etc).

#### Graph visualisation

You need :

- [graphviz](http://www.graphviz.org/) (ie. dot tool)
- a visualizer:
  we tested [zgrviewer](http://zvtm.sourceforge.net/zgrviewer.html),
  [xdot](https://pypi.python.org/pypi/xdot),
  [kgraphviewer](https://extragear.kde.org/apps/kgraphviewer/),
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
- objects that are not in a yellow box are Coq objects.

### dpdusage: find unused definitions via .dpd file

You can use ``dpdusage`` command to find unused definitions.
Example:

```
$ ./dpdusage tests/graph2.dpd
Info: read file tests/graph2.dpd
Permutation_app_swap	(0)
```

In the example above it reports that ``Permutation_app_swap`` was
references 0 times.  You can specify max number of references allowed
(default 0) via ``-threshold`` command line option.

## Development information

### Generated ``.dpd`` format description

```
graph : obj_list
obj : node | edge

node : "N: " node_id node_name node_attributes ';'
node_id : [0-9]+
node_name : '"' string '"'
node_attributes :
   | empty
   | '[' node_attribute_list ']'
node_attribute_list :
   | empty
   | node_attribute ',' node_attribute_list
node_attribute :
   | kind=[cnst|inductive|construct]
   | prop=[yes|no]
   | path="m0.m1.m2"
   | body=[yes|no]

edge : "E: "  node_id node_id edge_attributes ';'
edge_attributes :
   | empty
   | '[' edge_attribute_list ']'
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

Also see:
- [CHANGES](CHANGES.md)
- [distributed versions](https://anne.pacalet.fr/dev/dpdgraph/)

