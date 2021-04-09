open Parse
open Turtle

(*
Author -> Gabriel
Version -> 1.0
Recursive -> yes
Description -> Transform a string list into a string (concat all elements)
Param -> str_list : A string list
Return -> A string
*)
let rec get_str str_list =
  match str_list with
  | [] -> ""
  | s :: str_list -> s ^ get_str str_list;;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Get the dimension (in config) 
               and return a string int the form " <width>x<height>"
Param -> fd : A file descriptor (read)
Return -> A string
*)
let load_graph_dim fd =
  let width = get_next fd false [] in
  let height = get_next fd false [] in
  if width = [] || height = [] then 
  invalid_arguments "Config invalid format\n" else ();
  " " ^ get_str width ^ "x" ^ get_str height;;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Get the starting positions and angle (in config) 
               and return a Turtle.position with the informations
Param -> fd : A file descriptor (read)
Return -> A Turtle.position
*)
let load_starting_pos fd =
  let new_x = get_next fd false [] in
  let new_y = get_next fd false [] in
  let new_a = get_next fd false [] in
  if new_x = [] || new_y = [] || new_a = [] then
  invalid_arguments "Config invalid format\n" else ();
  let new_x = float_of_string (get_str new_x) in
  let new_y = float_of_string (get_str new_y) in
  let new_a = int_of_string (get_str new_a) in
  {x = new_x; y = new_y; a = new_a};;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Parse the config, 
               open the graphic window with the requested dimension 
               and return the starting position
Return -> A Turtle.position
*)
let config () =
  if not (Sys.file_exists "config") then 
  invalid_arguments "Missing config\n" else ();
  let fd = open_in "config" in
  Graphics.open_graph (load_graph_dim fd);
  let position = load_starting_pos fd in
  close_in fd;
  position;;
