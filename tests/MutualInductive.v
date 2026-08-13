(* Each member of a mutual inductive block refers to its siblings, so the
   dependency graph must contain those edges.  Elimination schemes are off so
   the graph is just the block itself. *)

Unset Elimination Schemes.

Inductive expr : Type :=
  | OfVal : val -> expr
with val : Type :=
  | RecV : expr -> val.
