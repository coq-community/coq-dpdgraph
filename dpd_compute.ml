(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(*            This file is part of the DpdGraph tools.                        *)
(*   Copyright (C) 2009-2015 Anne Pacalet (Anne.Pacalet@free.fr)           *)
(*             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                *)
(*        This file is distributed under the terms of the                     *)
(*         GNU Lesser General Public License Version 2.1                      *)
(*        (see the enclosed LICENSE file for mode details)                    *)
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

let debug_flag = ref false
let with_defs = ref true
let reduce_trans = ref true
let modules_only = ref false

let pp intro format = Format.printf "%s" intro ; Format.printf format

let debug format =
  if !debug_flag then pp "(debug): " format
  else Format.ifprintf Format.std_formatter format

let error format = pp "Error: " format
let warning format = pp "Warning: " format
let feedback format = pp "Info: " format

type error =
  | OpenFileError of string
  | LexicalError of Lexing.position * string
  | UnterminatedComment of Lexing.position option
  | ParsingError of Lexing.position * Lexing.position
  | EdgeWithoutNode of int
  | NodeWithSameId of int * string * string

exception Error of error

let pp_lex_pos fmt p = Format.fprintf fmt "(line:%d, character:%d)"
                         p.Lexing.pos_lnum
                         (p.Lexing.pos_cnum - p.Lexing.pos_bol)

let pp_lex_inter fmt (p1, p2) =
  let l1 = p1.Lexing.pos_lnum in
  let c1 = p1.Lexing.pos_cnum - p1.Lexing.pos_bol in
  let l2 = p2.Lexing.pos_lnum in
  let c2 = p2.Lexing.pos_cnum - p2.Lexing.pos_bol in
  if l1 = l2 then
    if c1 = c2 then
      pp_lex_pos fmt p1
    else
      Format.fprintf fmt "(line:%d, character:%d-%d)" l1 c1 c2
  else
    Format.fprintf fmt "between %a and %a" pp_lex_pos p1 pp_lex_pos p2

let pp_error = function
  | OpenFileError msg ->
      error "%s.@." msg
  | LexicalError (pos, str) ->
      error "%a: illegal character '%s'.@." pp_lex_pos pos str
  | UnterminatedComment (Some pos) ->
      error "unterminated comment (started near %a).@." pp_lex_pos pos
  | UnterminatedComment None ->
      error "unterminated comment.@."
  | ParsingError (p1, p2) ->
      error "parsing error %a.@." pp_lex_inter (p1, p2)
  | EdgeWithoutNode node_id ->
      error "no node with number %d: cannot build edge.@." node_id
  | NodeWithSameId (node_id, old_name, name) ->
      error "a node named '%s' already has the number %d. \
             Cannot create new node named '%s' with the same number.@."
        old_name node_id name


let get_attrib a attribs =
  try Some (List.assoc a attribs) with Not_found -> None

let bool_attrib a attribs = match get_attrib a attribs with
  | Some "yes" -> Some true
  | Some "no" -> Some false
  | Some _ (* TODO : warning ? *)
  | None -> None

module Node = struct
  type t = int * string * (string * string) list

  let id (id, _, _) = id
  let name (_, name, _) = name
  let attribs (_, _, attribs) = attribs

  let get_attrib a n = get_attrib a (attribs n)
  let bool_attrib a n = bool_attrib a (attribs n)

  let hash n = id n
  let equal n1 n2 = id n1 = id n2
  let compare n1 n2 = compare (id n1) (id n2)
end
module Edge = struct
  type t = (string * string) list

  let get_attrib a e = get_attrib a e
  let bool_attrib a e = bool_attrib a e

  let compare e1 e2 = compare e1 e2
  let default = []
end
module G = Graph.Imperative.Digraph.ConcreteLabeled(Node)(Edge)
module GO = Graph.Oper.I(G)

type t_obj = N of Node.t | E of (int * int * (string * string) list)

let hashtbl_incr (ht : ('k,int) Hashtbl.t) (k : 'k) =
  match Hashtbl.find_opt ht k with
  | Some i -> Hashtbl.replace ht k (i+1)
  | None -> Hashtbl.replace ht k 1
;;

let transform_module_dep lobj =
  (* create a hash table from module names to module node ids *)
  let module_name_tbl = Hashtbl.create 10 in
  let fill_module_name_tbl o = match o with
    | N (_, _, attr) -> begin
      match List.find_map (fun (k,v) -> if k="path" then Some v else None) attr with
      | Some p ->
        if not (Hashtbl.mem module_name_tbl p)
        then Hashtbl.replace module_name_tbl p (Hashtbl.length module_name_tbl)
      | None -> ()
      end
    | E _ -> ()
  in
  List.iter fill_module_name_tbl lobj;

  (* create a hash table from node ids to module node ids *)
  let node_id_tbl = Hashtbl.create 10 in
  let fill_node_id_tbl o = match o with
    | N (id, _, attr) -> begin
      match List.find_map (fun (k,v) -> if k="path" then Some v else None) attr with
      | Some p -> Hashtbl.replace node_id_tbl id (Hashtbl.find module_name_tbl p)
      | None -> ()
      end
    | E _ -> ()
  in
  List.iter fill_node_id_tbl lobj;

  (* create a hash table with module edges -> multiplicity *)
  let edge_tbl = Hashtbl.create 10 in
  let fill_edge_tbl o = match o with
    | N _ -> ()
    | E (id1, id2, _) ->
      let mid1 = Hashtbl.find node_id_tbl id1 in
      let mid2 = Hashtbl.find node_id_tbl id2 in
      hashtbl_incr edge_tbl (mid1,mid2)
  in
  List.iter fill_edge_tbl lobj;

  (* create new object list *)
  let ln = Hashtbl.fold (fun n i l -> N (i,n,[("kind", "module")])::l) module_name_tbl [] in
  let le = Hashtbl.fold (fun (i1,i2) m l -> if i1<>i2 then E (i1,i2,[("weight", string_of_int m)]) :: l else l) edge_tbl [] in
  ln @ le
;;

let build_graph lobj =
  let lobj = if !modules_only then transform_module_dep lobj else lobj in
  let g = G.create () in
  let node_tbl = Hashtbl.create 10 in
  let get_node id =
    try Hashtbl.find node_tbl id
    with Not_found -> raise (Error (EdgeWithoutNode id))
  in
  let add_obj o = match o with
    | N ((id, _, _) as n) ->
      begin
        try
          let old_n = Hashtbl.find node_tbl id in
          raise (Error (NodeWithSameId (id, Node.name old_n, Node.name n)))
        with Not_found ->
          Hashtbl.add node_tbl id n;
          let n = G.V.create n in G.add_vertex g n
      end
    | E (id1, id2, attribs) ->
        let e = G.E.create (get_node id1) attribs (get_node id2) in
        G.add_edge_e g e
  in List.iter add_obj lobj;
    g

(** remove edge (n1 -> n2) iff n2 is indirectly reachable by n1,
 * or if n1 and n2 are the same *)
let reduce_graph g = ignore (GO.replace_by_transitive_reduction g);;

let remove_node g n =
  let transfer_edges p =
    G.remove_edge g p n;
    List.iter (fun s -> G.add_edge g p s) (G.succ g n)
  in
    List.iter transfer_edges (G.pred g n);
    G.remove_vertex g n (* also remove edges n -> s *)

let remove_some_nodes g =
  let do_v v = match Node.bool_attrib "prop" v with
    | None | Some false -> remove_node g v
    | Some true -> ()
  in
  G.iter_vertex do_v g

let simplify_graph g =
  if not !with_defs then remove_some_nodes g;
  if !reduce_trans then reduce_graph g;
