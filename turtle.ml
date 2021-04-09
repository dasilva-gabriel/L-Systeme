open Graphics

type command =
  | Line of int
  | Move of int
  | Turn of int
  | Store
  | Restore;;
  
type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}
  
(** Put here any type and function implementations concerning turtle *)

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Calculate the next x position with the angle and the length
Param -> old_x : The previous x
Param -> angle : The angle of the position
Param -> length : The length of the distance
Return -> A float representing the new x position
*)
let get_new_x old_x angle length =
  let radian_angle = (float_of_int angle) *. Float.pi /. 180. in
  old_x +. ((float_of_int length) *. (cos radian_angle));;
 
(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Calculate the next y position with the angle and the length
Param -> old_y : The previous y
Param -> angle : The angle of the position
Param -> length : The length of the distance
Return -> A float representing the new y position
*)
let get_new_y old_y angle length =
  let radian_angle = (float_of_int angle) *. Float.pi /. 180. in
  old_y +. ((float_of_int length) *. (sin radian_angle));;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Calculate the next angle
Param -> old_a : The previous angle
Param -> angle : The angle to be added
Return -> An integer representing the new angle
*)
let get_new_a old_a angle =
  let new_a = old_a + angle in
  if new_a >= 360 then old_a + angle - 360 else new_a;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Create the next position with the previous position 
               and the length
Param -> old_x : The previous x
Param -> old_y : The previous y
Param -> old_a : The previous angle
Param -> length : The length of the distance (can be 0 if we just change angle)
Param -> angle : The angle to be added (can be 0 if we just change coords)
Return -> The new position
*)
let create_pos old_x old_y old_a length angle = 
  let new_x = get_new_x old_x old_a length in
  let new_y = get_new_y old_y old_a length in
  let new_a = get_new_a old_a angle in
  {x = new_x; y = new_y; a = new_a};;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Execute the command and update the position
Param -> cmd : The command to be applied
Param -> pos : The current position
Param -> scale : The scale to be applied
Return -> The new position
*)
let exec_command cmd pos scale =
  match cmd with
  | Line n -> 
    let new_pos = create_pos pos.x pos.y pos.a (n / scale) 0 in
    lineto (int_of_float new_pos.x) (int_of_float new_pos.y); new_pos
  | Move n ->
    let new_pos = create_pos pos.x pos.y pos.a (n / scale) 0 in
    moveto (int_of_float new_pos.x) (int_of_float new_pos.y); new_pos
  | Turn n -> create_pos pos.x pos.y pos.a 0 n
  | _ -> pos;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Generate a random color
Return -> A random Graphics.color
*)
let rdm_color () = 
  rgb (Random.int 256) (Random.int 256) (Random.int 256);;

(*
Author -> Hugo
Version -> 1.0
Recursive -> yes
Description -> Execute the commands in cmd_list and update the position
Param -> cmd_list : The commands list
Param -> pos : The current position
Param -> pos_stack : The stack used to store and restore positions
Param -> color_stack : The stack used to store and restore colors
Param -> scale : The scale to be applied
Return -> The new position
*)
let rec exec cmd_list pos pos_stack color_stack scale =
  match cmd_list with
  | [] -> ()
  | Store :: cmd_list -> 
    let new_color = rdm_color () in
    Stack.push pos pos_stack;
    Stack.push new_color color_stack;
    set_color new_color;
    exec cmd_list pos pos_stack color_stack scale
  | Restore :: cmd_list ->
    let last_pos = Stack.pop pos_stack in
    set_color (Stack.pop color_stack);
    moveto (int_of_float last_pos.x) (int_of_float last_pos.y);
    exec cmd_list last_pos pos_stack color_stack scale
  | cmd :: cmd_list -> 
    let _ = wait_next_event [Mouse_motion] in
    exec cmd_list (exec_command cmd pos scale) pos_stack color_stack scale;;
