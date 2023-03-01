  $ cat > missing_node.err.dpd << EOF
  > N: 1 "one";
  > N: 2 "two";
  > N: 4 "four";
  > E: 1 3;
  > EOF

  $ dpd2dot missing_node.err.dpd
  Info: read file missing_node.err.dpd
  Error: no node with number 3: cannot build edge.
