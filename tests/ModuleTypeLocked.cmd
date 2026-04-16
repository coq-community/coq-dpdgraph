Require Import dpdgraph.dpdgraph.

Require ModuleTypeLocked.
Set DependGraph File "ModuleTypeLocked.dpd".
Print DependGraph ModuleTypeLocked.Foo.T.
Set DependGraph File "ModuleTypeLocked_regular.dpd".
Print DependGraph ModuleTypeLocked.Regular.
Set DependGraph File "ModuleTypeLocked_axiom.dpd".
Print DependGraph ModuleTypeLocked.Ax.
