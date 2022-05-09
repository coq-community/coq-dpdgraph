Set Universe Polymorphism.

Definition foo (A: Type) (B: A -> Type) (C: A -> Type) (c: {x : A & {_ : B x & C x}}) : {x : A & {_ : C x & B x}}.
Proof.
destruct c as [a [b c]].
exists a, c. exact b.
Defined.
