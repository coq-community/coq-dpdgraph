From Stdlib Require Import Arith.PeanoNat.

Require Import dpdgraph.dpdgraph.
Set DependGraph File "PeanoNatBitwise.dpd".
Print DependGraph Stdlib.Arith.PeanoNat.Nat.PrivateImplementsBitwiseSpec.land_spec.
