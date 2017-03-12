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
let strict_whitelist = ref false

let threshold_option = ref 0

module Ident_set = Set.Make(String)

let whitelisted = ref Ident_set.empty

let add_whitelisted_item s =
  whitelisted := Ident_set.add s !whitelisted

let remove_surrounding_white_space s =
  let i = ref 0 in
  let j = ref (String.length s - 1) in
  while !i <= !j && (s.[!i] = ' ' || s.[!i] = '\t') do
    incr i
  done;
  while !i <= !j && (s.[!j] = ' ' || s.[!j] = '\t') do
    decr j
  done;
  String.sub s !i (!j - !i + 1)

let add_whitelist_file f =
  let ic =
    try open_in f
    with Sys_error m ->
      Dpd_compute.error "Whitelist file %s: %s@.Exit.@." f m;
      exit 1
  in
  try while true do
        let line = input_line ic in
        let line = remove_surrounding_white_space line in
        if String.length line > 0 && line.[0] <> '#'
        then add_whitelisted_item line
      done
  with End_of_file ->
    close_in ic

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
  ("-whitelist", Arg.String add_whitelisted_item,
      "path:ident : whitelist path:ident");
  ("-whitelist-file", Arg.String add_whitelist_file,
      "file : whitelist content of file");
  ("-strict-whitelist", Arg.Set strict_whitelist,
      ": warn about whitelisted items above threshold");
  ("-liberal-whitelist", Arg.Clear strict_whitelist,
      ": don't warn about whitelisted items (default)");
  ("-v", Arg.Set version_option,
      ": print version and exit");
]

let print_usage g t =
  let print_node n =
    let d = (G.in_degree g n) in
    if d <= t then
      let prefix = match Node.get_attrib "path" n with
          | None -> ""
          | Some p -> p
      in
      let long_id = prefix ^ ":" ^ (Node.name n) in
      if Ident_set.mem long_id !whitelisted then
        begin
          if !strict_whitelist then
            whitelisted := Ident_set.remove long_id !whitelisted
        end
      else
        if !print_path_option then
          Format.printf "%s:%s\t(%d)\n" prefix (Node.name n) d
        else
          Format.printf "%s\t(%d)\n" (Node.name n) d
  in
  G.iter_vertex print_node g

let warn_on_unused_whitelite threshold =
  if not (Ident_set.is_empty !whitelisted) then begin
      Dpd_compute.warning
        "The following whitelisted items do not \
         appear@ or are above threshold %d:@."
        threshold;
      Ident_set.iter
        (Format.printf "\t%s@.")
        !whitelisted
    end

let do_file _ f =
  try
    Dpd_compute.feedback "read file %s@." f;
    let g = Dpd_lex.read f in
    let g = Dpd_compute.build_graph g in
    Dpd_compute.simplify_graph g;
    print_usage g !threshold_option;
    if !strict_whitelist then
      warn_on_unused_whitelite !threshold_option
  with Dpd_compute.Error msg -> Dpd_compute.error "%s@." msg

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
