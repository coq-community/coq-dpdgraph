  $ coqc -R . dpdgraphtests Polymorph.v

  $ coqtop -R . dpdgraphtests -R ../theories dpdgraph -I ../src < PolymorphCmd.v | sed -e 's/Welcome to Coq.*/Welcome to Coq/'  
  
  Coq < 
  Coq < Coq < 
  Coq < 
  Coq < Coq < 
  Coq < 
  Welcome to Coq
  [Loading ML file coq-dpdgraph.plugin ... done]
  Info: output dependencies in file Polymorph.dpd

  $ cat Polymorph.dpd
  N: 1 "foo" [body=yes, kind=cnst, prop=no, path="Polymorph", ];
  N: 2 "sigT" [kind=inductive, prop=no, ];
  N: 3 "existT" [kind=construct, prop=no, ];
  E: 1 2 [weight=15, ];
  E: 1 3 [weight=2, ];

  $ dpd2dot Polymorph.dpd
  Info: read file Polymorph.dpd
  Info: Graph output in Polymorph.dot

  $ cat Polymorph.dot
  digraph Polymorph {
    graph [ratio=0.5]
    node [style=filled]
  Polymorph_foo [label="foo", URL=<Polymorph.html#foo>, peripheries=3, fillcolor="#F070D1"] ;
  _sigT [label="sigT", URL=<.html#sigT>, fillcolor="#E2CDFA"] ;
  _existT [label="existT", URL=<.html#existT>, fillcolor="#7FAAFF"] ;
    Polymorph_foo -> _sigT [] ;
    Polymorph_foo -> _existT [] ;
  subgraph cluster_Polymorph { label="Polymorph"; fillcolor="#FFFFC3"; labeljust=l; style=filled 
  Polymorph_foo; };
  } /* END */
