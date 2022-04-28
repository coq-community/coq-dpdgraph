  $ coqc -R .. dpdgraph Test.v > /dev/null 2>&1

  $ cat > search.cmd <<EOF
  > Require Import dpdgraph.dpdgraph.
  > 
  > Require Import Test.
  > 
  > SearchDepend Test.Permutation_app_swap.
  > EOF

  $ coqtop -R .. dpdgraph -I .. < search.cmd | sed -e 's/Welcome to Coq.*/Welcome to Coq/'
  
  Coq < 
  Coq < Coq < Toplevel input, characters 1-21:
  > Require Import Test.
  > ^^^^^^^^^^^^^^^^^^^^
  Warning: Notation "_ :: _" was already used in scope list_scope.
  [notation-overridden,parsing]
  Toplevel input, characters 1-21:
  > Require Import Test.
  > ^^^^^^^^^^^^^^^^^^^^
  Warning: Notation "_ ++ _" was already used in scope list_scope.
  [notation-overridden,parsing]
  
  Coq < Coq < 
  Coq < 
  Welcome to Coq
  [Loading ML file coq-dpdgraph.plugin ... done]
  Fetching opaque proofs from disk for dpdgraph.tests.Test
  [cons(42) nil(6) perm_swap(1) perm_skip(3) list(18) Permutation(11) app(43)
  Permutation_trans(3) eq_ind_r(1) eq_ind(2) list_ind(2) Permutation_refl(2)
  app_comm_cons(1) app_nil_end(2) Permutation_sym(3) ]
