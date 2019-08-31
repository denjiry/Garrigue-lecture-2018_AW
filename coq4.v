Definition prod_ind (A B:Set) (P:prod A B -> Prop) :=
 fun (f : forall a b, P (pair a b)) =>
 fun p => match p as x return P x with pair a b => f a b end. 

Check prod_ind.
(* : forall (A B : Set) (P : A * B -> Prop),
  (forall (a : A) (b : B), P (a, b)) -> forall p : A * B, P p   *)


Definition sum_ind (A B:Set) (P:sum A B -> Prop) :=
fun (fl : forall a, P (inl _ a)) (fr : forall b, P (inr _ b)) =>
fun p => match p as x return P x
with inl a => fl a | inr b => fr b end.

Check sum_ind.
(*: forall (A B : Set) (P : A + B -> Prop),
   (forall a : A, P (inl B a)) -> (forall b : B, P (inr A b)) ->
   forall p : A + B, P p *)

Fixpoint nat_ind (P:nat -> Prop) (f0:P O) (fn:forall n, P n -> P (S n))
(n : nat) {struct n} :=
match n as x return P x
with O => f0 | S m => fn m (nat_ind P f0 fn m) end.

Check nat_ind.
(* : forall P : nat -> Prop, P 0 -> (forall n : nat, P n -> P (S n)) ->
   forall n : nat, P n  *)

(*
�O��Ȃ���� induction n �Ƃ������͂��̕��𗘗p���邪�C��Ƃ����Ȃ蕡�G�ł���D
1. n ���܂ޑS�Ẳ�����S�[���ɖ߂��D(��� revert H1 ... Hn �ł��蓮�łł���)
2. n �̌^�����āC�^�� t a1 . . . an �Ȃ�΁Capply (t ind a1 . . . an) ���s���D(���̃X�e�b�v�͍�� elim n �ł��ł���)
�����ɂ́C�S�[���̃\�[�g�ɂ���� t rec, t ind, t rect �̂����ꂩ���g����D
3. �V�����ł����e�S�[���ɑ΂��āC����������D(intros �ɂ�����)
destruct �� induction/elim �͂悭���Ă��邪�C��҂��������ꂽ���𗘗p���Ă���̂ŁC
���ʂ�������肷��D
*)

Lemma plus_0 : forall n, plus n 0 = n.
Proof.
  apply nat_ind. reflexivity.
  intros n IHn.
  simpl.
  rewrite IHn.
  reflexivity.
Qed.


(* �����̒�` *)
Inductive even : nat -> Prop :=
| even_O : even O
| even_SS : forall n, even n -> even (S (S n)).

(* �A�[�I�q����ؖ�����藝 *)
Theorem even_double : forall n, even (n + n).
Proof.
  induction n.
  apply even_O.
  simpl.
  rewrite <- plus_n_Sm.
  apply even_SS.
  assumption.
Qed.

(* �A�[�I�q��ɑ΂���A�[�@���ł��� *)
Theorem even_plus : forall m n, even m -> even n -> even (m + n).
Proof.
  intros m n Hm Hn.
  induction Hm.
  apply Hn.
  simpl.
  apply even_SS.
  assumption.
Qed.

(*
���� Coq �̘_�������q�̂قƂ�ǂ��A�[�I�q��Ƃ��Ē�`����Ă���D
Inductive and (A B : Prop) : Prop := conj : A -> B -> A /\ B.
Inductive or (A B : Prop) : Prop :=
 or_introl : A -> A \/ B | or_intror : B -> A \/ B.
*)

(*
Inductive ex (A : Type) (P : A -> Prop) : Prop :=
 ex_intro : forall x : A, P x -> exists x, P x.

Inductive False : Prop := .
 *)

(*
and�Aor �� ex �ɂ��� destruct ���g�������R�����̒�`���@�ł���D
�������CFalse �͍ŏ����炠����̂ł͂Ȃ��C�\���q�̂Ȃ��q��Ƃ��Ē�`����Ă���D����
�����A�[�@�̕����݂�Ɩʔ����D
*)

Print False_rect.
(* fun (P : Type) (f : False) => match f return P with end
   : forall P : Type, False -> P     *)

(* ���傤�ǁC�����̋K���ɑΉ����Ă���D���@ elim �ł��ꂪ�g����D  *)

Theorem contradict : forall (P Q : Prop),
P -> ~P -> Q.
Proof.
  intros P Q p np.
  elim np.
  assumption.
Qed.

(* ���K��� 2.1 �ȉ��̒藝���ؖ�����D *)
Module Ex4_1.
Inductive odd : nat -> Prop :=
| odd_1 : odd 1
| odd_SS : forall n, odd n -> odd (S (S n)).

Theorem even_odd : forall n, even n -> odd (S n).
Proof.
  intros n.
  induction n.
  intros ev0. apply odd_1.
  intros evsn. (* apply IHn. apply odd_SS. *)
  
Admitted.

Theorem odd_even : forall n, odd n -> even (S n).
Proof.
Admitted.

Theorem even_not_odd : forall n, even n -> ~odd n.
Proof.
Admitted.

Theorem even_or_odd : forall m, even m \/ odd m.
Proof.
Admitted.

Theorem odd_odd_even : forall m n, odd m -> odd n -> even (m+n).
Proof.
Admitted.

End Ex4_1.



Fixpoint vec (n:nat) (T:Set) :=
match n with
| 0 => unit
| S m => (vec m T * T)%type
end.

Check ((tt, 1, 2, 3) : vec 3 nat).

(*
���̒��œ��� S = Set �܂��� S = Prop �̏ꍇ�𑽑��I�Ƃ����B�֐���藝���C�ӂ̃f�[�^�^
�܂��͔C�ӂ̖���ɂ��Ē�`�����B
�W�����C�u�����̃��X�g �T�^�I�ȑ����I�ȃf�[�^�\���Ƃ��āA���X�g����������B
*)


Require Import List.

Module Lists.

Print list.
(* Inductive list (A : Type) : Type := (* �^���������� *)
   nil : list A | cons : A -> list A -> list A   *)

Definition l1 := 1 :: 2 :: 3 :: 4 :: nil. (* cons �� :: �Ə����� *)
Print l1.
(* l1 = 1 :: 2 :: 3 :: 4 :: nil
   : list nat   *)

(*
Definition hd {A:Set} (l:list A) := (* { } �� A ���ȗ��\�ɂȂ� *)
match l with
| cons a _ => a
end. *)
(* Error: Non exhaustive pattern-matching: no clause found for pattern nil *)

Definition hd {A:Set} (d:A) (l:list A) :=
match l with
| cons a _ => a
| nil => d (* nil �̂Ƃ��� d ��Ԃ� *)
end.

Eval compute in hd 0 l1.
(* = 1
   : nat   *)

Fixpoint length {A:Set} (l : list A) := (* ���� *)
match l with
| nil => 0
| cons _ l' => 1 + length l'
end.

Eval compute in length l1.
(* = 4
   : nat  *)

Fixpoint append {A:Set} (l1 l2:list A) : list A := (* ���� *)
match l1 with
| nil => l2
| a :: l' => a :: append l' l2
end.

Eval compute in append (1 :: 2 :: nil) (3 :: 4 :: nil).
(* = 1 :: 2 :: 3 :: 4 :: nil
   : list nat  *)

Fixpoint fold_right {A B:Set} (f : A -> B -> B) (z : B) (l : list A) :=
match l with
| nil => z
| a :: l' => f a (fold_right f z l')
end.

(* fold_right ? b (a1 :: . . . :: an) = a1 ? . . . ? an ? b *)

Definition sum := fold_right plus 0.
Eval compute in sum l1.
(* = 10
   : nat  *)

Eval compute in fold_right mult 1 l1.
(* = 24
   : nat *)

End Lists.

(* ���K��� 3.1 ���������W���̃��X�g�Ƃ��Ē�`����BZ ��̑�����������_ x �Ōv�Z����֐����`����B *)

Module Ex4_2.

Require Import ZArith.
Open Scope Z_scope.


Fixpoint eval_poly (p : list Z) (x : Z) :=
  match p with
  | nil => 0
  | z :: p' => z + x * (eval_poly p' x)
  end.

Eval compute in eval_poly (1 :: 2 :: 3 :: nil) 5. (* = 1 + 2*5 + 3*5*5 *)

End Ex4_2.

(* �������Ƙ_�� Coq �̘_�����Z�q�� Inductive �Œ�`����Ă��邪�A���͑����I�Ș_�����Ƃ��Ē�`�ł���B*)

Definition and' (P Q : Prop) := forall (X : Prop), (P -> Q -> X) -> X.
Definition or' (P Q : Prop) := forall (X : Prop), (P -> X) -> (Q -> X) -> X.
Definition False' := forall (X : Prop), X.
Definition Equal' (T : Type) (x y : T) := forall (P : T -> Prop), P x <-> P y.

Theorem and'_ok : forall P Q, and' P Q <-> P /\ Q.
Proof.
  split.
  intros.
  apply H.
  split; assumption.
  unfold and'.
  intros pq X pqx.
  destruct pq as [p q].
  apply pqx; assumption.
Qed.

Theorem or'_ok : forall P Q, or' P Q <-> P \/ Q.
Proof.
Admitted.

Theorem False'_ok : False' <-> False.
Proof.
split. intros.
unfold False' in H.
apply H.
(* intros []. *)
intros F.
apply False_ind.
assumption.
Qed.

Theorem Equal'_ok : forall T x y, Equal' T x y <-> x = y.
Proof.
split.
unfold Equal'.
intros xy.
apply xy.
reflexivity.
intros xy T'.
split.
rewrite xy. intros. assumption.
rewrite xy. intros. assumption.
Qed.
(* ���K��� 3.2 or�f ok�AFalse�f ok ����� Equal�f ok ���ؖ����� *)
