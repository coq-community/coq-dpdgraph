val version_option : bool ref
val out_file : string option ref
val set_out_file : string -> unit
val graphname : string option ref
val set_graphname : string -> unit
val spec_args : (string * Arg.spec * string) list
val do_file : int -> string -> unit
val main : unit -> unit
