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


type t_obj = N of Node.t | E of (int * int * (string * string) list)

let build_graph lobj =
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
 * or if n1 and n2 are the same.
 *
 * The graph can have cycles: the members of a mutual inductive block refer to
 * each other.  So both the reachability and the "is this edge redundant" test
 * are computed on the strongly connected components, over the acyclic graph
 * they form, rather than by recursing along the edges of each node -- that
 * recursion does not terminate on a cycle, and asking whether n2 is reachable
 * from n1 in two steps or more would answer yes for every edge entering a
 * cycle, leaving the node it comes from isolated.
 *
 * Edges between two distinct nodes of the same component are kept: each of
 * them is redundant in the above sense, so removing them would drop the cycle
 * from the graph altogether. *)
let reduce_graph g =
  (* a table in which each component is mapped to the set of components
   * indirectly accessible from it *)
  let module Cset = Set.Make (Int) in
  let module Scc = Graph.Components.Make (G) in
  let nb_scc, scc_of = Scc.scc g in
  let succs = Array.make nb_scc [] in
  G.iter_vertex
    (fun v -> let c = scc_of v in succs.(c) <- G.succ g v @ succs.(c)) g;
  let reach_tbl = Array.make nb_scc None in
  let rec reachable c = match reach_tbl.(c) with
    | Some set -> set (* already done *)
    | None ->
        let add set s =
          let cs = scc_of s in
          (* the components below [c] are reached through the successors of
           * [c]'s own members, which are all in [succs.(c)] already *)
          if cs = c then set
          else Cset.union (Cset.add cs set) (reachable cs)
        in
        let set = List.fold_left add Cset.empty succs.(c) in
          reach_tbl.(c) <- Some set;
          set
  in
  let reduce v =
    let c = scc_of v in
    let nb_succ_before = List.length (G.succ g v) in
    (* the components reachable from [v] in two steps or more *)
    let acc =
      List.fold_left (fun acc s -> Cset.union acc (reachable (scc_of s)))
        Cset.empty (G.succ g v)
    in
    let rm_edge sv =
      let cs = scc_of sv in
      if Node.equal v sv || (cs <> c && Cset.mem cs acc) then
        G.remove_edge g v sv
    in
    List.iter rm_edge (G.succ g v);
    let nb_succ_after = List.length (G.succ g v) in
    debug "Reduce for %s : %d -> %d@." (Node.name v)
      nb_succ_before nb_succ_after
  in
    G.iter_vertex reduce g

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
