  $ coqc -R . dpdgraphtests PrimitiveProjections.v
  File "./PrimitiveProjections.v", line 6, characters 0-69:
  Warning: Notation "{ _ : _ & _ }" was already used in scope type_scope.
  [notation-overridden,parsing]

  $ coqtop -R . dpdgraphtests -R ../theories dpdgraph -I ../src < PrimitiveProjectionsCmd.v | sed -e 's/Welcome to Coq.*/Welcome to Coq/'
  
  Coq < 
  Coq < Coq < 
  Coq < 
  Coq < 
  Coq < 
  Coq < Coq < 
  Coq < 
  Welcome to Coq
  [Loading ML file coq-dpdgraph.plugin ... done]
  Info: output dependencies in file PrimitiveProjections.dpd
  Info: output dependencies in file PrimitiveProjections2.dpd
  $ cat PrimitiveProjections.dpd
  N: 3 "bar" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 2 "baz" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 1 "foo" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 5 "projT1" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 4 "projT2" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 7 "sigT" [kind=inductive, prop=no, path="PrimitiveProjections", ];
  N: 6 "existT" [kind=construct, prop=no, path="PrimitiveProjections", ];
  E: 1 6 [weight=2, ];
  E: 1 7 [weight=8, ];
  E: 2 7 [weight=2, ];
  E: 3 5 [weight=1, ];
  E: 3 7 [weight=1, ];
  E: 4 7 [weight=2, ];
  E: 5 7 [weight=2, ];

  $ dpd2dot PrimitiveProjections.dpd
  Info: read file PrimitiveProjections.dpd
  Info: Graph output in PrimitiveProjections.dot

  $ cat PrimitiveProjections.dot
  digraph PrimitiveProjections {
    graph [ratio=0.5]
    node [style=filled]
  PrimitiveProjections_foo [label="foo", URL=<PrimitiveProjections.html#foo>, peripheries=3, fillcolor="#F070D1"] ;
  PrimitiveProjections_baz [label="baz", URL=<PrimitiveProjections.html#baz>, peripheries=3, fillcolor="#F070D1"] ;
  PrimitiveProjections_bar [label="bar", URL=<PrimitiveProjections.html#bar>, peripheries=3, fillcolor="#F070D1"] ;
  PrimitiveProjections_projT2 [label="projT2", URL=<PrimitiveProjections.html#projT2>, peripheries=3, fillcolor="#F070D1"] ;
  PrimitiveProjections_projT1 [label="projT1", URL=<PrimitiveProjections.html#projT1>, fillcolor="#F070D1"] ;
  PrimitiveProjections_existT [label="existT", URL=<PrimitiveProjections.html#existT>, fillcolor="#7FAAFF"] ;
  PrimitiveProjections_sigT [label="sigT", URL=<PrimitiveProjections.html#sigT>, fillcolor="#E2CDFA"] ;
    PrimitiveProjections_foo -> PrimitiveProjections_existT [] ;
    PrimitiveProjections_foo -> PrimitiveProjections_sigT [] ;
    PrimitiveProjections_baz -> PrimitiveProjections_sigT [] ;
    PrimitiveProjections_bar -> PrimitiveProjections_projT1 [] ;
    PrimitiveProjections_projT2 -> PrimitiveProjections_sigT [] ;
    PrimitiveProjections_projT1 -> PrimitiveProjections_sigT [] ;
  subgraph cluster_PrimitiveProjections { label="PrimitiveProjections"; fillcolor="#FFFFC3"; labeljust=l; style=filled 
  PrimitiveProjections_sigT; PrimitiveProjections_existT; PrimitiveProjections_projT1; PrimitiveProjections_projT2; PrimitiveProjections_bar; PrimitiveProjections_baz; PrimitiveProjections_foo; };
  } /* END */


  $ cat PrimitiveProjections2.dpd
  N: 8 "foo" [body=yes, kind=cnst, prop=no, path="PrimitiveProjections", ];
  N: 9 "sigT" [kind=inductive, prop=no, path="PrimitiveProjections", ];
  N: 10 "existT" [kind=construct, prop=no, path="PrimitiveProjections", ];
  E: 8 9 [weight=8, ];
  E: 8 10 [weight=2, ];

  $ dpd2dot PrimitiveProjections2.dpd
  Info: read file PrimitiveProjections2.dpd
  Info: Graph output in PrimitiveProjections2.dot

  $ cat PrimitiveProjections2.dot
  digraph PrimitiveProjections2 {
    graph [ratio=0.5]
    node [style=filled]
  PrimitiveProjections_foo [label="foo", URL=<PrimitiveProjections.html#foo>, peripheries=3, fillcolor="#F070D1"] ;
  PrimitiveProjections_sigT [label="sigT", URL=<PrimitiveProjections.html#sigT>, fillcolor="#E2CDFA"] ;
  PrimitiveProjections_existT [label="existT", URL=<PrimitiveProjections.html#existT>, fillcolor="#7FAAFF"] ;
    PrimitiveProjections_foo -> PrimitiveProjections_sigT [] ;
    PrimitiveProjections_foo -> PrimitiveProjections_existT [] ;
  subgraph cluster_PrimitiveProjections { label="PrimitiveProjections"; fillcolor="#FFFFC3"; labeljust=l; style=filled 
  PrimitiveProjections_existT; PrimitiveProjections_sigT; PrimitiveProjections_foo; };
  } /* END */

