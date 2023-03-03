(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(*            This file is part of the DpdGraph tools.                        *)
(*   Copyright (C) 2009-2017 Anne Pacalet (Anne.Pacalet@free.fr)           *)
(*             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                *)
(*        This file is distributed under the terms of the                     *)
(*         GNU Lesser General Public License Version 2.1                      *)
(*        (see the enclosed LICENSE file for mode details)                    *)
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

{
  module P = Dpd_parse (* tokens *)

  let comment_pos = ref None
  let start_comment pos =
    comment_pos := Some pos
}

let blank = [' ' '\t' ]
let newline = ['\n']
let letter =  ['a'-'z']|['A'-'Z']
let digit =  ['0'-'9']
let number = ['0'-'9']+
let first_letter = letter | '_'
let other_letter = first_letter | digit
let ident = first_letter other_letter*

rule token = parse
  | blank+                    { token lexbuf }     (* skip blanks *)
  | newline                   { Lexing.new_line lexbuf; token lexbuf }
  | "/*"                      { start_comment (Lexing.lexeme_start_p lexbuf);
                                let _ = comment lexbuf in token lexbuf }
  | "//" [^'\n']* newline     { token lexbuf }

  | "N:"                      { P.NODE }
  | "E:"                      { P.EDGE }
  | '['                       { P.LBRACKET }
  | ']'                       { P.RBRACKET }

  | ","                       { P.COMMA }
  | ";"                       { P.SEMICOL }
  | "="                       { P.EQUAL }

  | ident as s            { P.IDENT s }
  | number as s           { P.NUM (int_of_string s) }

  | '"' ([^'"']+ as str) '"' { P.STRING (str)}

  | eof               { P.EOF }
  | _               {
                      let str = String.escaped (Lexing.lexeme lexbuf) in
                      let pos = Lexing.lexeme_start_p lexbuf in
                      let err = Dpd_compute.LexicalError (pos, str) in
                      raise (Dpd_compute.Error err)
                    }

and comment = parse
        "*/"                  { () }
  |     newline               { Lexing.new_line lexbuf; comment lexbuf }
  |     _                     { comment lexbuf }
  | eof { let err = Dpd_compute.UnterminatedComment (!comment_pos) in
          raise (Dpd_compute.Error err) }

{
  (* @raise Dpd_compute.Error e *)
  let read filename =
    let buf_in =
      try open_in filename
        with Sys_error msg ->
          let err = Dpd_compute.OpenFileError msg in
          raise (Dpd_compute.Error err)
    in
    let lexbuf = Lexing.from_channel buf_in in
    let init_pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { init_pos with Lexing.pos_fname = filename };
    let info = P.graph token lexbuf in
    close_in buf_in;
    info

}
