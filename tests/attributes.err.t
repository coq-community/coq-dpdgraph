  $ cat >attributes.err.dpd <<EOF
  > N: 1 "one"; /* no attibute */
  > N: 2 "two" []; /* empty attributes */
  > N: 3 "three" [ kind=cnst, ] ; /* known attribute with known value */
  > N: 4 "four" [ kind=unknown, ] ; /* known attribute with unknown value */
  > N: 5 "five" [ prop=yes, prop=no, ] ; /* known attribute with two values.
  >                                         Should this be an error?
  >                                       */
  > N: 6 "six" [ another_attribute=42, ]; /* unknown attribute */
  > 
  > E: 1 1;  /* no attibute */
  > E: 1 2 []; /* empty attributes */
  > E: 1 3 [ weight=1, ] ; /* known attribute with known value */
  > E: 1 4 [ weight="value", ] ; /* known attribute with unknown value */
  > 
  > /* should not have an error before this one: */
  > E: 1 10;
  > EOF

  $ dpd2dot attributes.err.dpd
  Info: read file attributes.err.dpd
  Error: no node with number 10: cannot build edge.
