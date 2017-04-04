(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
(*            This file is part of the DpdGraph tools.                        *)
(*   Copyright (C) 2009-2015 Anne Pacalet (Anne.Pacalet@free.fr)           *)
(*             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                *)
(*        This file is distributed under the terms of the                     *)
(*         GNU Lesser General Public License Version 2.1                      *)
(*        (see the enclosed LICENSE file for mode details)                    *)
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

module G = Dpd_compute.G
module Node = Dpd_compute.Node

let version_option = ref false
let print_path_option = ref true

let threshold_option = ref 0

let spec_args = [
  ("-with-defs", Arg.Set Dpd_compute.with_defs,
      ": show everything (default)");
  ("-without-defs", Arg.Clear Dpd_compute.with_defs,
      ": show only Prop objects");
  ("-rm-trans", Arg.Set Dpd_compute.reduce_trans,
      ": remove transitive dependencies (default)");
  ("-keep-trans", Arg.Clear Dpd_compute.reduce_trans,
      ": keep transitive dependencies");
  ("-debug", Arg.Set Dpd_compute.debug_flag,
      ": set debug mode");
  ("-threshold", Arg.Set_int threshold_option,
      ": Max number of references allowed (default 0)");
  ("-with-path", Arg.Set print_path_option,
      ": print path (default)");
  ("-without-path", Arg.Clear print_path_option,
      ": do not print path");
  ("-v", Arg.Set version_option,
      ": print version and exit");
]

let print_usage g t =
  let print_node n =
    let d = (G.in_degree g n) in
    if d <= t then
      if !print_path_option then
        let prefix = match Node.get_attrib "path" n with
          | None -> ""
          | Some d -> d^":"
        in Format.printf "%s%s\t(%d)\n" prefix (Node.name n) d
      else
        Format.printf "%s\t(%d)\n" (Node.name n) d
  in
  G.iter_vertex print_node g

let do_file _ f =
  try
    Dpd_compute.feedback "read file %s@." f;
    let g = Dpd_lex.read f in
    let g = Dpd_compute.build_graph g in
    Dpd_compute.simplify_graph g;
    print_usage g !threshold_option
  with Dpd_compute.Error err -> Dpd_compute.pp_error err

let main () =
  let usage_msg = "Usage : "^(Sys.argv.(0))^" [options] <input_file.dpd>" in
  let args = ref [] in
  let memo_arg arg = args := arg :: !args in
    Arg.parse spec_args memo_arg usage_msg;
    if !version_option
    then Format.printf "This is '%s' (part of DpdGraph tools - version %s)@."
           (Filename.basename Sys.argv.(0)) Version.version
    else match !args with
      |  [] -> Dpd_compute.error "no source file to process ?@.";
               Arg.usage spec_args usage_msg
      | f::[]  -> do_file 0 f
      | l  ->
          ignore (List.fold_left (fun n f -> do_file n f; n+1) 1 l)

let () = main ()
