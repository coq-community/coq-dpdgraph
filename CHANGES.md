# Changelog

- [03/04/2017] Move configure.in into configure.ac and rewrite it
- [21/02/2017] Add the -graphname option (default: name of the input file)
               (from JasonGross)
- [09/01/2017] Make the software work with coq 8.6
- [09/05/2016] Add dpdusage to find unused definitions (from Vadim Zaliva).
- [26/02/2016] Make the software work with coq 8.5, fix the computation of
  axioms, constructors, and propositions, switch from a stand-alone program to
  a coq plugin.
- [28/09/2015] Check that the GitHub version is up-to-date
             + minor updates in Copyrights and README.
- [26/02/2014] Change the name from dpdgraph to coq-dpdgraph
             and start to move to GitHub.
- [24/02/2014] Add missing "Declarations.force_opaque"  for Coq 8.4
             thanks to Yves Bertot. Working version now.
- [24/02/2014] Version 0.4b : fix compilation problems with Coq 8.4,
             but it is not working. Published it anyway to get some help.
- [24/04/2013] Version 0.3:
             Adaptation for Coq 8.3 + better Makefile (thanks to Julien Narboux)
- [18/09/2009] Add licence and distribute as version 0.2.
- [07/08/2009] Arguments for FileDependGraph don't need ``""`` anymore
             + module names checking and 'globalisation'
             (Patch from Hugo Herbelin)
- [24/07/2009] Add attributes on edges
- [24/07/2009] Count the number of time an object is used by another one
- [24/07/2009] Hierarchical subgraphs
- [24/07/2009] Add URL to coqdoc in .dot nodes for .svg export
- [24/07/2009] Tests management in Makefile
- [23/07/2009] Better handling of special characters in names and identification
- [23/07/2009] Identification of dot graph nodes by their full COQ names
             instead of a number.
- [23/07/2009] First locally distributed version.


# History

These tools are based on the function ``SearchDepend`` that Yves Bertot posted
on ``Coq-Club`` at on the February 27th, 2009.

I first tried to generate a graph directly from COQ, but it becomes rapidly huge
and difficult to use. It appears that we need a tool to be able to filter what
we really want to see.
So finally, I have made a simple file generation from coq to export every useful
information. The idea is to have external tools to read the information file and
generate whatever we want.  I think it will be easier to maintain and extend.
