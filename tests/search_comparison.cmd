Require Import dpdgraph.dpdgraph.

Require Import Test.

(* Test to demonstrate the difference between SearchDepend and SearchDependRecursive *)

(* Direct dependencies only *)
SearchDepend Test.app_ass.

(* All transitive dependencies *)
SearchDependRecursive Test.app_ass.

(* Another example *)
SearchDepend Test.in_cons.

SearchDependRecursive Test.in_cons.
