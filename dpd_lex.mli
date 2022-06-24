module P = Dpd_parse
val comment_pos : Lexing.position option ref
val start_comment : Lexing.position -> unit
val __ocaml_lex_tables : Lexing.lex_tables
val token : Lexing.lexbuf -> P.token
val __ocaml_lex_token_rec : Lexing.lexbuf -> int -> P.token
val comment : Lexing.lexbuf -> unit
val __ocaml_lex_comment_rec : Lexing.lexbuf -> int -> unit
val read : string -> Dpd_compute.t_obj list
