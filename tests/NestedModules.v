(* -*- mode: coq; coq-prog-args: ("-emacs" "-w" "-deprecated-native-compiler-option,-native-compiler-disabled" "-native-compiler" "ondemand" "-R" "." "Top" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Bignums" "Bignums" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Cheerios" "Cheerios" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/CoqEAL" "CoqEAL" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Coqprime" "Coqprime" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Coquelicot" "Coquelicot" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/ExtLib" "ExtLib" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Flocq" "Flocq" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/HB" "HB" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/ITree" "ITree" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/InfSeqExt" "InfSeqExt" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Interval" "Interval" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/LF" "LF" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/LeanImport" "LeanImport" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Ltac2" "Ltac2" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/MenhirLib" "MenhirLib" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Paco" "Paco" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/QuickChick" "QuickChick" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/RecordUpdate" "RecordUpdate" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Rewriter" "Rewriter" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/SimpleIO" "SimpleIO" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/StructTact" "StructTact" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/VST" "VST" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/Verdi" "Verdi" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/compcert" "compcert" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/coqutil" "coqutil" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/deriving" "deriving" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/dpdgraph" "dpdgraph" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/elpi" "elpi" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/elpi_elpi" "elpi_elpi" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/elpi_examples" "elpi_examples" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/extructures" "extructures" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/iris" "iris" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/iris_ora" "iris_ora" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/mathcomp" "mathcomp" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/riscv" "riscv" "-Q" "/mnt/disks/data/jason/.opam/4.14.2/lib/coq/user-contrib/stdpp" "stdpp" "-top" "Top.make_dpd") -*- *)
(* File reduced by coq-bug-minimizer from original input, then from 21 lines to 5 lines, then from 19 lines to 204 lines, then from 211 lines to 59 lines, then from 73 lines to 2518 lines, then from 2521 lines to 80 lines, then from 94 lines to 809 lines, then from 816 lines to 164 lines, then from 178 lines to 286 lines, then from 293 lines to 196 lines, then from 210 lines to 2673 lines, then from 2675 lines to 262 lines, then from 276 lines to 1462 lines, then from 1469 lines to 306 lines, then from 320 lines to 1362 lines, then from 1369 lines to 359 lines, then from 373 lines to 383 lines, then from 390 lines to 359 lines, then from 374 lines to 361 lines, then from 376 lines to 188 lines, then from 203 lines to 188 lines *)
(* coqc version 9.1+alpha compiled with OCaml 4.14.2
   coqtop version 9.1+alpha
   Expected coqc runtime on this file: 0.592 sec
   Expected coqc peak memory usage on this file: 454800.0 kb *)
Require Stdlib.Floats.SpecFloat.
Require Stdlib.Reals.Reals.
Import Stdlib.ZArith.ZArith.

Record radix := { radix_val :> Z ; radix_prop : Zle_bool 2 radix_val = true }.
Fixpoint digits2_Pnat (n : positive) : nat.
Admitted.

Section Fcore_digits.

Variable beta : radix.

Section digits_aux.

Variable p : Z.

Fixpoint Zdigits_aux (nb pow : Z) (n : nat) { struct n } : Z :=
  match n with
  | O => nb
  | S n => if Zlt_bool p pow then nb else Zdigits_aux (nb + 1) (Zmult beta pow) n
  end.

End digits_aux.

Definition Zdigits n :=
  match n with
  | Z0 => Z0
  | Zneg p => Zdigits_aux (Zpos p) 1 beta (digits2_Pnat p)
  | Zpos p => Zdigits_aux n 1 beta (digits2_Pnat p)
  end.

End Fcore_digits.
Import Stdlib.Reals.Reals.

Definition Rcompare x y :=
  match total_order_T x y with
  | inleft (left _) => Lt
  | inleft (right _) => Eq
  | inright _ => Gt
  end.

Section pow.

Variable r : radix.

Definition bpow e :=
  match e with
  | Zpos p => IZR (Zpower_pos r p)
  | Zneg p => Rinv (IZR (Zpower_pos r p))
  | Z0 => 1%R
  end.

Record mag_prop x := {
  mag_val :> Z ;
  _ : (x <> 0)%R -> (bpow (mag_val - 1)%Z <= Rabs x < bpow mag_val)%R
}.

Definition mag :
  forall x : R, mag_prop x.
Admitted.

End pow.

Section Def.

Record float (beta : radix) := Float { Fnum : Z ; Fexp : Z }.

Arguments Fnum {beta}.
Arguments Fexp {beta}.

Variable beta : radix.

Definition F2R (f : float beta) :=
  (IZR (Fnum f) * bpow beta (Fexp f))%R.

End Def.
Arguments F2R {beta}.

Notation location := SpecFloat.location (only parsing).
Notation loc_Exact := SpecFloat.loc_Exact (only parsing).
Notation loc_Inexact := SpecFloat.loc_Inexact (only parsing).

Section Fcalc_bracket.

Variable d u : R.

Variable x : R.

Inductive inbetween : location -> Prop :=
  | inbetween_Exact : x = d -> inbetween loc_Exact
  | inbetween_Inexact l : (d < x < u)%R -> Rcompare x ((d + u) / 2)%R = l -> inbetween (loc_Inexact l).

End Fcalc_bracket.

Section Fcalc_bracket_step.
Variable nb_steps : Z.

Definition new_location_even k l :=
  if Zeq_bool k 0 then
    match l with loc_Exact => l | _ => loc_Inexact Lt end
  else
    loc_Inexact
    match Z.compare (2 * k) nb_steps with
    | Lt => Lt
    | Eq => match l with loc_Exact => Eq | _ => Gt end
    | Gt => Gt
    end.

Definition new_location_odd k l :=
  if Zeq_bool k 0 then
    match l with loc_Exact => l | _ => loc_Inexact Lt end
  else
    loc_Inexact
    match Z.compare (2 * k + 1) nb_steps with
    | Lt => Lt
    | Eq => match l with loc_Inexact l => l | loc_Exact => Lt end
    | Gt => Gt
    end.

Definition new_location :=
  if Z.even nb_steps then new_location_even else new_location_odd.

End Fcalc_bracket_step.

Section Fcalc_bracket_generic.

Variable beta : radix.

Definition inbetween_float m e x l :=
  inbetween (F2R (Float beta m e)) (F2R (Float beta (m + 1) e)) x l.

End Fcalc_bracket_generic.

Section Generic.

Variable beta : radix.

Variable fexp : Z -> Z.

Definition cexp x :=
  fexp (mag beta x).

End Generic.

Module Export Flocq_DOT_Calc_DOT_Div_WRAPPED.
Module Export Div.

Section Fcalc_div.

Variable beta : radix.

Variable fexp : Z -> Z.

Definition Fdiv_core m1 e1 m2 e2 e :=
  let (m1', m2') :=
    if Zle_bool e (e1 - e2)%Z
    then (m1 * Zpower beta (e1 - e2 - e), m2)%Z
    else (m1, m2 * Zpower beta (e - (e1 - e2)))%Z in
  let '(q, r) :=  Z.div_eucl m1' m2' in
  (q, new_location m2' r loc_Exact).

Definition Fdiv (x y : float beta) :=
  let (m1, e1) := x in
  let (m2, e2) := y in
  let e' := ((Zdigits beta m1 + e1) - (Zdigits beta m2 + e2))%Z in
  let e := Z.min (Z.min (fexp e') (fexp (e' + 1))) (e1 - e2) in
  let '(m, l) := Fdiv_core m1 e1 m2 e2 e in
  (m, e, l).

Theorem Fdiv_correct :
  forall x y,
  (0 < F2R x)%R -> (0 < F2R y)%R ->
  let '(m, e, l) := Fdiv x y in
  (e <= cexp beta fexp (F2R x / F2R y))%Z /\
  inbetween_float beta m e (F2R x / F2R y) l.
Admitted.

End Fcalc_div.

End Div.
End Flocq_DOT_Calc_DOT_Div_WRAPPED.
Module Export Flocq.
Module Export Calc.
Module Export Div.
Include Flocq_DOT_Calc_DOT_Div_WRAPPED.Div.
End Div.
End Calc.
End Flocq.

Require Import dpdgraph.dpdgraph.
Set DependGraph File "NestedModules.dpd".
Print DependGraph Flocq.Calc.Div.Fdiv_correct.
