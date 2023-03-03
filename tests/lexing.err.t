  $ cat > lexing.err.dpd << EOF
  > N: 1 "one";
  > N: 2 "two" !
  > N: 4 "four";
  > E: 1 3;
  > EOF

  $ dpd2dot lexing.err.dpd
  Info: read file lexing.err.dpd
  Error: (line:2, character:11): illegal character '!'.
