%{

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(*            This file is part of the DpdGraph tools.                        *)
(*   Copyright (C) 2009-2015 Anne Pacalet (Anne.Pacalet@free.fr)           *)
(*             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                *)
(*        This file is distributed under the terms of the                     *)
(*         GNU Lesser General Public License Version 2.1                      *)
(*        (see the enclosed LICENSE file for mode details)                    *)
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

%}

%token <string> IDENT
%token <string> STRING
%token <int> NUM
%token LBRACKET RBRACKET
%token NODE EDGE EQUAL COMMA SEMICOL EOF

%left LBRACKET
%nonassoc IDENT

%type <Dpd_compute.t_obj list> graph
%start graph
%%

graph : obj_list EOF { $1 }

obj_list :
    | obj { [$1] }
    | obj obj_list { $1::$2 }


obj :
    | node SEMICOL { $1 }
    | edge SEMICOL { $1 }
    | error { let p_start = symbol_start_pos () in
              let p_end = symbol_end_pos () in
              let err = Dpd_compute.ParsingError (p_start, p_end) in
              raise (Dpd_compute.Error err)
            }

node : NODE NUM STRING opt_attribs { Dpd_compute.N ($2, $3, $4) }

edge : EDGE NUM NUM opt_attribs { Dpd_compute.E ($2, $3, $4) }

opt_attribs :
    | /* empty */ { [] }
    | LBRACKET attribs RBRACKET { $2 }

attribs :
    | /* empty */ { [] }
    | attrib COMMA attribs { $1::$3 }

attrib :
    | IDENT EQUAL attrib_value { ($1, $3) }

attrib_value:
    | IDENT { $1 }
    | STRING { $1 }
    | NUM { string_of_int $1 }

%%
