open Graphics
open Turtle

(** Words, rewrite systems, and rewriting *)

type 's word =
  | Symb of 's
  | Seq of 's word list
  | Branch of 's word

type 's rewrite_rules = 's -> 's word

type 's system = {
    axiom : 's word;
    rules : 's rewrite_rules;
    interp : 's -> Turtle.command list 
}

(** Put here any type and function implementations concerning systems *)

(*
Author -> Gabriel
Version -> 1.0
Recursive -> yes
Description -> Applied the rules to the axiom
Param -> word : The axiom of the system
Param -> rules : The rules function of the system
Return -> A 's word with the rules applied
*)
let rec apply_rules word rules =
  let rec apply_rules_on_seq seq =
    match seq with
    | [] -> []
    | s :: seq -> [apply_rules s rules] :: apply_rules_on_seq seq in
  match word with
  | Symb s -> rules s;
  | Seq q -> Seq (List.concat (apply_rules_on_seq q))
  | Branch b -> Branch( Seq [apply_rules b rules]);;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> yes
Description -> Convert the axiom in command list
Param -> word : The axiom of the system
Param -> itpr : The interpretations function of the system
Return -> A command list
*)
let rec word_to_cmd word itpr =
  let rec seq_to_cmd seq =
    match seq with
    | [] -> []
    | s :: seq -> (word_to_cmd s itpr) @ seq_to_cmd seq in
  match word with
  | Symb s -> itpr s
  | Seq q -> seq_to_cmd q
  | Branch b -> [Turtle.Store] @ (word_to_cmd b itpr) @ [Turtle.Restore];;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> no
Description -> Create a new system for the next iteration
Param -> system : The system
Return -> A 's system
*)
let create_system system = {
  axiom = (apply_rules system.axiom system.rules); 
  rules = system.rules;
  interp =  system.interp
};;

(*
Author -> Gabriel
Version -> 1.0
Recursive -> yes
Description -> If the user press q, then quit the program else
               process to the next iteration
Param -> system : The 's system
Param -> pos : The current position after the next iteration
Param -> pos_stack : The stack containing the position
Param -> color_stack : The stack containing the color
Param -> scale : The scale to be applied on the length of Move and Line
*)
let rec next_step system pos pos_stack color_stack scale =
  moveto 0 0;
  draw_string "Press q for quit or any key to continue";
  moveto (int_of_float pos.x) (int_of_float pos.y);
  let key = wait_next_event[Key_pressed] in
  match key.key with
  | 'q' -> close_graph ()
  | _ ->
    clear_graph ();
    let cmd_list = word_to_cmd system.axiom system.interp in
    exec cmd_list pos pos_stack color_stack scale;
    let next_sys = create_system system in
    next_step next_sys pos pos_stack color_stack ((scale * 2) - (scale / 2));;
