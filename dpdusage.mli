module G = Dpd_compute.G
module Node = Dpd_compute.Node
val version_option : bool ref
val print_path_option : bool ref
val threshold_option : int ref
val spec_args : (string * Arg.spec * string) list
val print_usage : G.t -> int -> unit
val do_file : 'a -> string -> unit
val main : unit -> unit
