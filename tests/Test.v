(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, * CNRS-Ecole Polytechnique-INRIA Futurs-Universite Paris Sud *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

(*i $Id: List.v 10999 2008-05-27 15:55:22Z letouzey $ i*)

Set Implicit Arguments.

Set Warnings "-notation-overridden".

(******************************************************************)
(** * Basics: definition of polymorphic lists and some operations *)
(******************************************************************)

(** ** Definitions *)

Section Lists.

  Variable A : Type.

  Inductive list : Type :=
    | nil : list
    | cons : A -> list -> list.

  Infix "::" := cons (at level 60, right associativity) : list_scope.

  Open Scope list_scope.

  (** Head and tail        *)
  Definition head (l:list) :=
    match l with
      | nil => error
      | x :: _ => value x
    end.

 Definition hd (default:A) (l:list) :=
   match l with
     | nil => default
     | x :: _ => x
   end.

  Definition tail (l:list) : list :=
    match l with
      | nil => nil
      | a :: m => m
    end.

  (** Length of lists                *)
  Fixpoint length (l:list) : nat :=
    match l with
      | nil => 0
      | _ :: m => S (length m)
    end.

Parameter size : list -> nat.
Axiom size_nil : size nil = 0.


  (** The [In] predicate *)
  Fixpoint In (a:A) (l:list) {struct l} : Prop :=
    match l with
      | nil => False
      | b :: m => b = a \/ In a m
    end.


  (** Concatenation of two lists *)
  Fixpoint app (l m:list) {struct l} : list :=
    match l with
      | nil => m
      | a :: l1 => a :: app l1 m
    end.

  Infix "++" := app (right associativity, at level 60) : list_scope.

End Lists.

(** Exporting list notations and tactics *)

Arguments nil {A}.
Infix "::" := cons (at level 60, right associativity) : list_scope.
Infix "++" := app (right associativity, at level 60) : list_scope.

Open Scope list_scope.

Delimit Scope list_scope with list.

Bind Scope list_scope with list.

Arguments list _%_type_scope.

(** ** Facts about lists *)

Section Facts.

  Variable A : Type.


  (** *** Genereric facts *)

  (** Discrimination *)
  Theorem nil_cons : forall (x:A) (l:list A), nil <> x :: l.
  Proof.
    intros; discriminate.
  Qed.


  (** Destruction *)

  Theorem destruct_list : forall l : list A, {x:A & {tl:list A | l = x::tl}}+{l = nil}.
  Proof.
    induction l as [|a tl].
    right; reflexivity.
    left; exists a; exists tl; reflexivity.
  Qed.

  (** *** Head and tail *)

  Theorem head_nil : head (@nil A) = None.
  Proof.
    simpl; reflexivity.
  Qed.

  Theorem head_cons : forall (l : list A) (x : A), head (x::l) = Some x.
  Proof.
    intros; simpl; reflexivity.
  Qed.


  (************************)
  (** *** Facts about [In] *)
  (************************)


  (** Characterization of [In] *)

  Theorem in_eq : forall (a:A) (l:list A), In a (a :: l).
  Proof.
    simpl in |- *; auto.
  Qed.

  Theorem in_cons : forall (a b:A) (l:list A), In b l -> In b (a :: l).
  Proof.
    simpl in |- *; auto.
  Qed.

  Theorem in_nil : forall a:A, ~ In a nil.
  Proof.
    unfold not in |- *; intros a H; inversion_clear H.
  Qed.

  Lemma In_split : forall x (l:list A), In x l -> exists l1, exists l2, l = l1++x::l2.
  Proof.
  induction l; simpl; destruct 1.
  subst a; auto.
  exists (@nil A); exists l; auto.
  destruct (IHl H) as (l1,(l2,H0)).
  exists (a::l1); exists l2; simpl; f_equal; auto.
  Qed.

  (** Inversion *)
  Theorem in_inv : forall (a b:A) (l:list A), In b (a :: l) -> a = b \/ In b l.
  Proof.
    intros a b l H; inversion_clear H; auto.
  Qed.

  (** Decidability of [In] *)
  Theorem In_dec :
    (forall x y:A, {x = y} + {x <> y}) ->
    forall (a:A) (l:list A), {In a l} + {~ In a l}.
  Proof.
    intro H; induction l as [| a0 l IHl].
    right; apply in_nil.
    destruct (H a0 a); simpl in |- *; auto.
    destruct IHl; simpl in |- *; auto.
    right; unfold not in |- *; intros [Hc1| Hc2]; auto.
  Defined.


  (*************************)
  (** *** Facts about [app] *)
  (*************************)

  (** Discrimination *)
  Theorem app_cons_not_nil : forall (x y:list A) (a:A), nil <> x ++ a :: y.
  Proof.
    unfold not in |- *.
    destruct x as [| a l]; simpl in |- *; intros.
    discriminate H.
    discriminate H.
  Qed.


  (** Concat with [nil] *)

  Theorem app_nil_end : forall l:list A, l = l ++ nil.
  Proof.
    induction l; simpl in |- *; auto.
    rewrite <- IHl; auto.
  Qed.

  (** [app] is associative *)
  Theorem app_ass : forall l m n:list A, (l ++ m) ++ n = l ++ m ++ n.
  Proof.
    intros. induction l; simpl in |- *; auto.
    now_show (a :: (l ++ m) ++ n = a :: l ++ m ++ n).
    rewrite <- IHl; auto.
  Qed.
  Hint Resolve app_ass : core.

  Theorem ass_app : forall l m n:list A, l ++ m ++ n = (l ++ m) ++ n.
  Proof.
    auto using app_ass.
  Qed.

  (** [app] commutes with [cons] *)
  Theorem app_comm_cons : forall (x y:list A) (a:A), a :: (x ++ y) = (a :: x) ++ y.
  Proof.
    auto.
  Qed.



  (** Facts deduced from the result of a concatenation *)

  Theorem app_eq_nil : forall l l':list A, l ++ l' = nil -> l = nil /\ l' = nil.
  Proof.
    destruct l as [| x l]; destruct l' as [| y l']; simpl in |- *; auto.
    intro; discriminate.
    intros H; discriminate H.
  Qed.

  Theorem app_eq_unit :
    forall (x y:list A) (a:A),
      x ++ y = a :: nil -> x = nil /\ y = a :: nil \/ x = a :: nil /\ y = nil.
  Proof.
    destruct x as [| a l]; [ destruct y as [| a l] | destruct y as [| a0 l0] ];
      simpl in |- *.
    intros a H; discriminate H.
    left; split; auto.
    right; split; auto.
    generalize H.
    generalize (app_nil_end l); intros E.
    rewrite <- E; auto.
    intros.
    injection H.
    intro.
    cut (nil = l ++ a0 :: l0); auto.
    intro.
    generalize (app_cons_not_nil _ _ _ H1); intro.
    elim H2.
  Qed.

  Lemma app_inj_tail :
    forall (x y:list A) (a b:A), x ++ a :: nil = y ++ b :: nil -> x = y /\ a = b.
  Proof.
    induction x as [| x l IHl];
      [ destruct y as [| a l] | destruct y as [| a l0] ];
      simpl in |- *; auto.
    intros a b H.
    injection H.
    auto.
    intros a0 b H.
    injection H; intros.
    generalize (app_cons_not_nil _ _ _ H0); destruct 1.
    intros a b H.
    injection H; intros.
    cut (nil = l ++ a :: nil); auto.
    intro.
    generalize (app_cons_not_nil _ _ _ H2); destruct 1.
    intros a0 b H.
    injection H; intros.
    destruct (IHl l0 a0 b H0).
    split; auto.
    rewrite <- H1; rewrite <- H2; reflexivity.
  Qed.


  (** Compatibility wtih other operations *)

  Lemma app_length : forall l l' : list A, length (l++l') = length l + length l'.
  Proof.
    induction l; simpl; auto.
  Qed.

  Lemma in_app_or : forall (l m:list A) (a:A), In a (l ++ m) -> In a l \/ In a m.
  Proof.
    intros l m a.
    elim l; simpl in |- *; auto.
    intros a0 y H H0.
    now_show ((a0 = a \/ In a y) \/ In a m).
    elim H0; auto.
    intro H1.
    now_show ((a0 = a \/ In a y) \/ In a m).
    elim (H H1); auto.
  Qed.

  Lemma in_or_app : forall (l m:list A) (a:A), In a l \/ In a m -> In a (l ++ m).
  Proof.
    intros l m a.
    elim l; simpl in |- *; intro H.
    now_show (In a m).
    elim H; auto; intro H0.
    now_show (In a m).
    elim H0. (* subProof completed *)
    intros y H0 H1.
    now_show (H = a \/ In a (y ++ m)).
    elim H1; auto 4.
    intro H2.
    now_show (H = a \/ In a (y ++ m)).
    elim H2; auto.
  Qed.

  Lemma app_inv_head:
   forall l l1 l2 : list A, l ++ l1 = l ++ l2 ->  l1 = l2.
  Proof.
    induction l; simpl; auto; injection 1; auto.
  Qed.

End Facts.

(*******************************************)
(** * Operations on the elements of a list *)
(*******************************************)

Section Elts.

  Variable A : Type.

  (*****************************)
  (** ** Nth element of a list *)
  (*****************************)

  Fixpoint nth (n:nat) (l:list A) (default:A) {struct l} : A :=
    match n, l with
      | O, x :: l' => x
      | O, _other => default
      | S m, nil => default
      | S m, x :: t => nth m t default
    end.

  Fixpoint nth_ok (n:nat) (l:list A) (default:A) {struct l} : bool :=
    match n, l with
      | O, x :: l' => true
      | O, _other => false
      | S m, nil => false
      | S m, x :: t => nth_ok m t default
    end.

  Lemma nth_in_or_default :
    forall (n:nat) (l:list A) (d:A), {In (nth n l d) l} + {nth n l d = d}.
  (* Realizer nth_ok. Program_all. *)
  Proof.
    intros n l d; generalize n; induction l; intro n0.
    right; case n0; trivial.
    case n0; simpl in |- *.
    auto.
    intro n1; elim (IHl n1); auto.
  Qed.

  Lemma nth_S_cons :
    forall (n:nat) (l:list A) (d a:A),
      In (nth n l d) l -> In (nth (S n) (a :: l) d) (a :: l).
  Proof.
    simpl in |- *; auto.
  Qed.

  Fixpoint nth_error (l:list A) (n:nat) {struct n} : Exc A :=
    match n, l with
      | O, x :: _ => value x
      | S n, _ :: l => nth_error l n
      | _, _ => error
    end.

  Definition nth_default (default:A) (l:list A) (n:nat) : A :=
    match nth_error l n with
      | Some x => x
      | None => default
    end.

  (*****************)
  (** ** Remove    *)
  (*****************)

  Section Remove.

    Hypothesis eq_dec : forall x y : A, {x = y}+{x <> y}.

    Fixpoint remove (x : A) (l : list A){struct l} : list A :=
      match l with
	| nil => nil
	| y::tl => if (eq_dec x y) then remove x tl else y::(remove x tl)
      end.

    Theorem remove_In : forall (l : list A) (x : A), ~ In x (remove x l).
    Proof.
      induction l as [|x l]; auto.
      intro y; simpl; destruct (eq_dec y x) as [yeqx | yneqx].
      apply IHl.
      unfold not; intro HF; simpl in HF; destruct HF; auto.
      apply (IHl y); assumption.
    Qed.

  End Remove.


(******************************)
(** ** Last element of a list *)
(******************************)

  (** [last l d] returns the last element of the list [l],
    or the default value [d] if [l] is empty. *)

  Fixpoint last (l:list A) (d:A)  {struct l} : A :=
  match l with
    | nil => d
    | a :: nil => a
    | a :: l => last l d
  end.

  (** [removelast l] remove the last element of [l] *)

  Fixpoint removelast (l:list A) {struct l} : list A :=
    match l with
      | nil =>  nil
      | a :: nil => nil
      | a :: l => a :: removelast l
    end.

  Lemma app_removelast_last :
    forall l d, l<>nil -> l = removelast l ++ (last l d :: nil).
  Proof.
    induction l.
    destruct 1; auto.
    intros d _.
    destruct l; auto.
    pattern (a0::l) at 1; rewrite IHl with d; auto; discriminate.
  Qed.

  Lemma exists_last :
    forall l, l<>nil -> { l' : (list A) & { a : A | l = l'++a::nil}}.
  Proof.
    induction l.
    destruct 1; auto.
    intros _.
    destruct l.
    exists (@nil A); exists a; auto.
    destruct IHl as [l' (a',H)]; try discriminate.
    rewrite H.
    exists (a::l'); exists a'; auto.
  Qed.

  Lemma removelast_app :
    forall l l', l' <> nil -> removelast (l++l') = l ++ removelast l'.
  Proof.
    induction l.
    simpl; auto.
    simpl; intros.
    assert (l++l' <> nil).
    destruct l.
    simpl; auto.
    simpl; discriminate.
    specialize (IHl l' H).
    destruct (l++l'); [elim H0; auto|f_equal; auto].
  Qed.


  (****************************************)
  (** ** Counting occurences of a element *)
  (****************************************)

  Hypotheses eqA_dec : forall x y : A, {x = y}+{x <> y}.

  Fixpoint count_occ (l : list A) (x : A){struct l} : nat :=
    match l with
      | nil => 0
      | y :: tl =>
	let n := count_occ tl x in
	  if eqA_dec y x then S n else n
    end.

  Lemma not_eq_S n : n <> S n.
  Proof.
  induction n;[discriminate | intros a; injection a; intros a'; case IHn; auto].
  Qed.

  Lemma S_gt_0 n : 0 < S n.
  Proof. induction n; [apply le_n | apply le_S]. auto. Qed.

  Hint Resolve S_gt_0 : core.

  (** Compatibility of count_occ with operations on list *)
  Theorem count_occ_In : forall (l : list A) (x : A), In x l <-> count_occ l x > 0.
  Proof.
    induction l as [|y l].
    simpl; intros; split; [destruct 1 | ].
    intros a; inversion a.
    simpl. intro x; destruct (eqA_dec y x) as [Heq|Hneq].
    rewrite Heq. now intuition auto with *.
    pose (IHl x). intuition auto with *.
  Qed.

  Theorem count_occ_inv_nil : forall (l : list A), (forall x:A, count_occ l x = 0) <-> l = nil.
  Proof.
    split.
    (* Case -> *)
    induction l as [|x l].
    trivial.
    intro H.
    elim (O_S (count_occ l x)).
    apply sym_eq.
    generalize (H x).
    simpl. destruct (eqA_dec x x) as [|HF].
    trivial.
    elim HF; reflexivity.
    (* Case <- *)
    intro H; rewrite H; simpl; reflexivity.
  Qed.

  Lemma count_occ_nil : forall (x : A), count_occ nil x = 0.
  Proof.
    intro x; simpl; reflexivity.
  Qed.

  Lemma count_occ_cons_eq : forall (l : list A) (x y : A), x = y -> count_occ (x::l) y = S (count_occ l y).
  Proof.
    intros l x y H; simpl.
    destruct (eqA_dec x y); [reflexivity | contradiction].
  Qed.

  Lemma count_occ_cons_neq : forall (l : list A) (x y : A), x <> y -> count_occ (x::l) y = count_occ l y.
  Proof.
    intros l x y H; simpl.
    destruct (eqA_dec x y); [contradiction | reflexivity].
  Qed.

End Elts.



(*******************************)
(** * Manipulating whole lists *)
(*******************************)

Section ListOps.

  Variable A : Type.

  (*************************)
  (** ** Reverse           *)
  (*************************)

  Fixpoint rev (l:list A) : list A :=
    match l with
      | nil => nil
      | x :: l' => rev l' ++ x :: nil
    end.

  Lemma distr_rev : forall x y:list A, rev (x ++ y) = rev y ++ rev x.
  Proof.
    induction x as [| a l IHl].
    destruct y as [| a l].
    simpl in |- *.
    auto.

    simpl in |- *.
    apply app_nil_end; auto.

    intro y.
    simpl in |- *.
    rewrite (IHl y).
    apply (app_ass (rev y) (rev l) (a :: nil)).
  Qed.

  Remark rev_unit : forall (l:list A) (a:A), rev (l ++ a :: nil) = a :: rev l.
  Proof.
    intros.
    apply (distr_rev l (a :: nil)); simpl in |- *; auto.
  Qed.

  Lemma rev_involutive : forall l:list A, rev (rev l) = l.
  Proof.
    induction l as [| a l IHl].
    simpl in |- *; auto.

    simpl in |- *.
    rewrite (rev_unit (rev l) a).
    rewrite IHl; auto.
  Qed.


  (** Compatibility with other operations *)

  Lemma In_rev : forall l x, In x l <-> In x (rev l).
  Proof.
    induction l.
    simpl; intuition.
    intros.
    simpl.
    intuition.
    subst.
    apply in_or_app; right; simpl; auto.
    apply in_or_app; left; firstorder.
    destruct (in_app_or _ _ _ H); firstorder.
  Qed.

  Lemma rev_length : forall l, length (rev l) = length l.
  Proof.
    induction l;simpl; auto.
    rewrite app_length.
    rewrite IHl.
    simpl.
    elim (length l); simpl; auto.
  Qed.

  Lemma Nat_sub_diag n : n - n = 0.
  Proof. induction n;[easy | simpl; easy]. Qed.

  Lemma Nat_sub_succ n m : S n - S m = n - m.
  Proof. easy. Qed.

  Lemma le_S_S n m : S n <= S m -> n <= m.
  Proof.
  induction m.
    intros H; inversion H;[easy | inversion H1].
    intros Sls; inversion Sls;[apply le_n | apply le_S; apply IHm; easy].
  Qed.
  Lemma app_nth2 (l : list A):
   forall l' d n, n >= length l -> nth n (l++l') d = nth (n-length l) l' d.
  Proof.
     induction l.
     intros.
     simpl.
     destruct n; auto.
     intros l' d n.
     case n; simpl; auto.
     intros.
     inversion H.
     intros.
     rewrite IHl.
       reflexivity.
     apply le_S_S. easy.
   Qed.

End ListOps.
