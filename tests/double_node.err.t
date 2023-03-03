  $ cat >double_node.err.dpd <<EOF
  > N: 1 "one";
  > N: 2 "two";
  > N: 4 "four";
  > N: 2 "another two";
  > EOF

  $ dpd2dot double_node.err.dpd
  Info: read file double_node.err.dpd
  Error: a node named 'two' already has the number 2. Cannot create new node named 'another two' with the same number.
