open Graphics
open Lsystems
open Systems
open Turtle

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Load the file passed as argument in lsys.ml and print a message
*)
let load () =
  Parse.construct_lsys Sys.argv;
  print_string ("Successfully loaded " ^ Sys.argv.(1) ^ "\n");;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Load the config, setup graphics specification and run the lsys
*)
let exec () =
  let position = Config.config () in
  set_line_width 2;
  moveto (int_of_float position.x) (int_of_float position.y);
  next_step Lsys.lsys position (Stack.create ()) (Stack.create ()) 1;;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> If there is an argument, load it, 
               otherwise run the lsys already loaded
*)
let main () =
  if Array.length Sys.argv > 1 then load () else exec ();;

let () = main ()
