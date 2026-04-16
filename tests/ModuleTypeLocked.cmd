Require Import dpdgraph.dpdgraph.

Require ModuleTypeLocked.
Set DependGraph File "ModuleTypeLocked.dpd".
Print DependGraph ModuleTypeLocked.Foo.T.
Set DependGraph File "ModuleTypeLocked_regular.dpd".
Print DependGraph ModuleTypeLocked.Regular.
Set DependGraph File "ModuleTypeLocked_axiom.dpd".
Print DependGraph ModuleTypeLocked.Ax.
Set DependGraph File "ModuleTypeLocked_type_only.dpd".
Set DependGraph TypeOnly.
Print DependGraph ModuleTypeLocked.Foo.T ModuleTypeLocked.Regular ModuleTypeLocked.Ax.
