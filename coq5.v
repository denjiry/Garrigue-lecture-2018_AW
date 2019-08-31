(* 2 �P�ꉻ�Ǝ����� *)

Require Import Arith.

Goal forall x, 1 + x = x + 1. (* Goal �Ŗ��O�̂Ȃ��藝���ؖ����� *)
  intros.
   (* 1 + x = x + 1 *)
  Check plus_comm.
   (* : forall n m : nat, n + m = m + n *)
  apply plus_comm.
Abort. (* �藝��o�^�����ɏؖ����I��点�� *)


Goal forall x y z, x + y + z = z + y + x.
  intros.
  Check eq_trans.
   (*  : forall (A : Type) (x y z : A), x = y -> y = z -> x = z *)
  (* apply eq_trans.
     Error: Unable to find an instance for the variable y.  *)
  eapply eq_trans. (* y �����_�Ɍ���Ȃ��̂ŁCeapply �ɕς��� *)
  (* x + y + z = ?13 *)
  apply plus_comm.
  eapply eq_trans.
  Check f_equal.
  (*: forall (A B : Type) (f : A -> B) (x y : A), x = y -> f x = f y *)
  apply f_equal. (* ?f = plus z *)
  apply plus_comm.
  apply plus_assoc.
  Restart. (* �ؖ������ɖ߂� *)
  intros.
  rewrite plus_comm. (* rewrite ���P�ꉻ���g�� *)
  rewrite (plus_comm x).
  apply plus_assoc.
Abort.


Goal
(forall P : nat -> Prop,
P 0 -> (forall n, P n -> P (S n)) -> forall n, P n)
-> forall n, n + 1 = 1 + n.
  intros H n. (* �S�Ă̕ϐ��� intro ���� *)
  apply H.
  Restart.
  intros H n.
  pattern n. (* pattern �Ő������q����\������ *)
  apply H.
  Restart.
  intros H. (* forall n ���c���Ƃ��܂����� *)
  apply H.
Abort.


(* ���K��� 2.1 �ȉ��̕����ؖ�����B *)
Section Coq5.

Require Import List.

Variable A : Set.
Variable op : A -> A -> A.
Variable e : A.

Hypothesis op_comm : forall x y, op x y = op y x.
Hypothesis op_assoc : forall x y z, op x (op y z) = op (op x y) z.
Hypothesis op_neutral : forall x, op e x = x.

Fixpoint reduce (l : list A) : A :=
match l with
| nil => e
| a :: l' => op a (reduce l')
end.

Lemma reduce_fold : forall l, reduce l = fold_right op e l.
Proof.
auto.
Qed.

Lemma reduce_app : forall l1 l2, reduce (l1 ++ l2) = op (reduce l1) (reduce l2).
Proof.
  intros.


End Coq5.
