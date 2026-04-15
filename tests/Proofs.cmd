Load "Proofs.v".
From dpdgraph Require Import dpdgraph.
Set Printing Fully Qualified.
Set DependGraph File "Proofs.dpd".
Print DependGraph Stdlib.Arith.PeanoNat.Nat.PrivateImplementsBitwiseSpec.land_spec.
Set DependGraph File "Proofs_type_only.dpd".
Set DependGraph TypeOnly.
Print DependGraph Stdlib.Arith.PeanoNat.Nat.PrivateImplementsBitwiseSpec.land_spec.
