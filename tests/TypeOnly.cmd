Require Import dpdgraph.dpdgraph.

Require TypeOnly.
Set Printing Fully Qualified.

(* Mode 1: proofs - AccessOpaque=true (default), TypeOnly=false (default) *)
Set DependGraph File "TypeOnly_proofs.dpd".
Print DependGraph TypeOnly.mylist TypeOnly.mylen TypeOnly.mylen_zero.

(* Mode 2: statements_body - AccessOpaque=false, TypeOnly=false *)
Set DependGraph File "TypeOnly_stmts_body.dpd".
Unset DependGraph AccessOpaque.
Print DependGraph TypeOnly.mylist TypeOnly.mylen TypeOnly.mylen_zero.

(* Mode 3: statements_type - TypeOnly=true *)
Set DependGraph File "TypeOnly_stmts_type.dpd".
Set DependGraph TypeOnly.
Print DependGraph TypeOnly.mylist TypeOnly.mylen TypeOnly.mylen_zero.
