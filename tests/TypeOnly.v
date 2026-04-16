(* Test for the TypeOnly flag.
   We define an inductive with constructor types referencing specific deps,
   a transparent definition, and an opaque lemma. The three modes
   (proofs, statements_body, statements_type) should each produce
   different dependency graphs. *)

Inductive mylist (A : nat -> Type) : nat -> Type :=
| mynil : mylist A 0
| mycons : forall n, A n -> mylist A n -> mylist A (S n).

Definition mylen (A : nat -> Type) (n : nat) (l : mylist A n) : nat := n.

Lemma mylen_zero (A : nat -> Type) : mylen A 0 (mynil A) = 0.
Proof. reflexivity. Qed.
