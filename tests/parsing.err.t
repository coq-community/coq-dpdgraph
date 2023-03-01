  $ cat > parsing.err.dpd << EOF
  > N: 1 "one";
  > N: 2 "two" xyz;
  > N: 4 "four";
  > E: 1 3;
  > EOF

  $ dpd2dot parsing.err.dpd
  Info: read file parsing.err.dpd
  Error: parsing error (line:2, character:11-14).
