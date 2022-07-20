module C = Dpd_compute
module G = Dpd_compute.G
module Node = Dpd_compute.Node
val color_soft_yellow : int
val color_pale_orange : int
val color_medium_orange : int
val color_soft_green : int
val color_medium_green : int
val color_soft_pink : int
val color_medium_pink : int
val color_soft_purple : int
val color_soft_blue : int
type attr_kind =
    Aid of string
  | Astr of string
  | Acolor of int
  | Aint of int
  | Aurl of string
val split_string : string -> int -> string * string
val mk_url : 'a * string * (string * string) list -> string
val node_attribs : G.t -> G.vertex -> (attr_kind * attr_kind) list
val add_node_in_subgraph :
  (string, int * (string * string) list * 'a list) Hashtbl.t ->
  'a -> string -> unit
val str2id : string -> string
val print_attribs :
  string -> Format.formatter -> (attr_kind * attr_kind) list -> unit
val node_dot_id : 'a * string * (string * string) list -> string
val print_subgraphs :
  Format.formatter ->
  (string,
   int * (string * string) list * ('a * string * (string * string) list) list)
  Hashtbl.t -> unit
val print_graph : String.t -> Format.formatter -> G.t -> unit
val graph_file : String.t -> string -> G.t -> unit
