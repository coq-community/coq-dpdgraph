coq-dpdgraph
============

Build dependency graphs between COQ objects,
where COQ is the famous formal proof management system (see
http://coq.inria.fr/).

# What's inside ?

First of all, it is a small tool (an extended COQ toplevel) that extracts the
dependencies between COQ objects, and produce a file (.dpd) with this 
information.
Then, another tool reads these .dpd files and produce graph file
using .dot format (cf. http://www.graphviz.org/) that makes possible to view
them.
The idea is that other small tools can be developed latter on to process
the .dpd files.
