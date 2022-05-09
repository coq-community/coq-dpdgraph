Require Import dpdgraph.dpdgraph.

Require PrimitiveProjections.
Set DependGraph File "PrimitiveProjections.dpd".
Print FileDependGraph PrimitiveProjections.
Set DependGraph File "PrimitiveProjections2.dpd".

Print DependGraph PrimitiveProjections.foo.
