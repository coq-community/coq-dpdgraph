  $ cat > unterminated_comment.err.dpd <<EOF
  > N: 1 "one";
  > N: 2 "two";
  > N: 4 "four"; /*
  > E: 1 3;
  > EOF

  $ dpd2dot unterminated_comment.err.dpd
  Info: read file unterminated_comment.err.dpd
  Error: unterminated comment (started near (line:3, character:13)).
