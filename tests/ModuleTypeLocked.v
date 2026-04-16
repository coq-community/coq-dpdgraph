(* Test file for module type locked bodies *)
(* When a module implements a module type signature with `:`, the body
   is hidden from the global environment's direct lookup. However, the body
   still exists in the module structure and can be accessed (like Extraction
   and Print Assumptions do). dpdgraph looks up the module structure to
   correctly detect that such constants have a body, reporting body=yes. *)

Module Type FooT.
  Axiom T : nat.
End FooT.

Module Foo : FooT.
  (* This definition has a body, but it's hidden by the module type *)
  Definition T := S O.
End Foo.

(* A regular definition for comparison - body=yes expected *)
Definition Regular := S O.

(* An axiom for comparison - body=no expected *)
Axiom Ax : nat.
