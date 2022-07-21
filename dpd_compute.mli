val debug_flag : bool ref
val with_defs : bool ref
val reduce_trans : bool ref
val pp : string -> ('a, Format.formatter, unit) format -> 'a
val debug : ('a, Format.formatter, unit) format -> 'a
val error : ('a, Format.formatter, unit) format -> 'a
val warning : ('a, Format.formatter, unit) format -> 'a
val feedback : ('a, Format.formatter, unit) format -> 'a
type error =
    OpenFileError of string
  | LexicalError of Lexing.position * string
  | UnterminatedComment of Lexing.position option
  | ParsingError of Lexing.position * Lexing.position
  | EdgeWithoutNode of int
  | NodeWithSameId of int * string * string
exception Error of error
val pp_lex_pos : Format.formatter -> Lexing.position -> unit
val pp_lex_inter :
  Format.formatter -> Lexing.position * Lexing.position -> unit
val pp_error : error -> unit
val get_attrib : 'a -> ('a * 'b) list -> 'b option
val bool_attrib : 'a -> ('a * string) list -> bool option
module Node :
  sig
    type t = int * string * (string * string) list
    val id : 'a * 'b * 'c -> 'a
    val name : 'a * 'b * 'c -> 'b
    val attribs : 'a * 'b * 'c -> 'c
    val get_attrib : 'a -> 'b * 'c * ('a * 'd) list -> 'd option
    val bool_attrib : 'a -> 'b * 'c * ('a * string) list -> bool option
    val hash : 'a * 'b * 'c -> 'a
    val equal : 'a * 'b * 'c -> 'a * 'd * 'e -> bool
    val compare : 'a * 'b * 'c -> 'a * 'd * 'e -> int
  end
module Edge :
  sig
    type t = (string * string) list
    val get_attrib : 'a -> ('a * 'b) list -> 'b option
    val bool_attrib : 'a -> ('a * string) list -> bool option
    val compare : 'a -> 'a -> int
    val default : 'a list
  end
module G :
  sig
    type t = Graph.Imperative.Digraph.ConcreteLabeled(Node)(Edge).t
    module V :
      sig
        type t = Node.t
        val compare : t -> t -> int
        val hash : t -> int
        val equal : t -> t -> bool
        type label = Node.t
        val create : label -> t
        val label : t -> label
      end
    type vertex = V.t
    module E :
      sig
        type t = Node.t * Edge.t * Node.t
        val compare : t -> t -> int
        type vertex = V.t
        val src : t -> vertex
        val dst : t -> vertex
        type label = Edge.t
        val create : vertex -> label -> vertex -> t
        val label : t -> label
      end
    type edge = E.t
    val is_directed : bool
    val is_empty : t -> bool
    val nb_vertex : t -> int
    val nb_edges : t -> int
    val out_degree : t -> vertex -> int
    val in_degree : t -> vertex -> int
    val mem_vertex : t -> vertex -> bool
    val mem_edge : t -> vertex -> vertex -> bool
    val mem_edge_e : t -> edge -> bool
    val find_edge : t -> vertex -> vertex -> edge
    val find_all_edges : t -> vertex -> vertex -> edge list
    val succ : t -> vertex -> vertex list
    val pred : t -> vertex -> vertex list
    val succ_e : t -> vertex -> edge list
    val pred_e : t -> vertex -> edge list
    val iter_vertex : (vertex -> unit) -> t -> unit
    val fold_vertex : (vertex -> 'a -> 'a) -> t -> 'a -> 'a
    val iter_edges : (vertex -> vertex -> unit) -> t -> unit
    val fold_edges : (vertex -> vertex -> 'a -> 'a) -> t -> 'a -> 'a
    val iter_edges_e : (edge -> unit) -> t -> unit
    val fold_edges_e : (edge -> 'a -> 'a) -> t -> 'a -> 'a
    val map_vertex : (vertex -> vertex) -> t -> t
    val iter_succ : (vertex -> unit) -> t -> vertex -> unit
    val iter_pred : (vertex -> unit) -> t -> vertex -> unit
    val fold_succ : (vertex -> 'a -> 'a) -> t -> vertex -> 'a -> 'a
    val fold_pred : (vertex -> 'a -> 'a) -> t -> vertex -> 'a -> 'a
    val iter_succ_e : (edge -> unit) -> t -> vertex -> unit
    val fold_succ_e : (edge -> 'a -> 'a) -> t -> vertex -> 'a -> 'a
    val iter_pred_e : (edge -> unit) -> t -> vertex -> unit
    val fold_pred_e : (edge -> 'a -> 'a) -> t -> vertex -> 'a -> 'a
    val create : ?size:int -> unit -> t
    val clear : t -> unit
    val copy : t -> t
    val add_vertex : t -> vertex -> unit
    val remove_vertex : t -> vertex -> unit
    val add_edge : t -> vertex -> vertex -> unit
    val add_edge_e : t -> edge -> unit
    val remove_edge : t -> vertex -> vertex -> unit
    val remove_edge_e : t -> edge -> unit
  end
type t_obj = N of Node.t | E of (int * int * (string * string) list)
val build_graph : t_obj list -> G.t
val reduce_graph : G.t -> unit
val remove_node : G.t -> G.vertex -> unit
val remove_some_nodes : G.t -> unit
val simplify_graph : G.t -> unit
