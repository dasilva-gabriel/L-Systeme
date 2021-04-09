open Systems
open List

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Error message while parsing the config or and argument
Param -> str : The message to be printed (string)
*)
let invalid_arguments str = 
  print_string "Invalid argument: ";
  print_string str;
  exit 0;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> yes
Description -> Browse the specified file to find the next lines 
               between empty lines/comments
Param -> fd : A file descriptor (read)
Param -> found : A boolean (used as breakpoint)
Param -> res : The return list (string list)
Return -> A string list containing the lines read
*)
let rec get_next fd found res =
  try 
    let line = input_line fd in
    if 
      String.length line = 0 || 
      String.get line 0 = '#' || 
      String.get line 0 = '\n' then 
      if found then res 
      else get_next fd false res else get_next fd true res @ [line]
  with End_of_file -> [];;

(*
Author -> Enseignant in Logique class (from the MP2)
Version -> 1.0
Recursive -> internal
Description -> Convert a string to a char list
Param -> s : The string to be converted
Return -> A char list
*)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) [];;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Convert a char to his interpretation ('L' becomes Line etc)
Param -> c : A char
Return -> A string
*)
let trad_itpr c =
  match c with
  | 'L' -> "[Line ("
  | 'M' -> "[Move ("
  | 'T' -> "[Turn ("
  | _ -> "";;

(*
Author -> Hugo
Version -> 1.0
Recursive -> yes
Description -> Convert the raw axiom into a char Systems.word
Param -> c_list : A char list
Return -> A string 
*)
let rec compl_axiom c_list =
  match c_list with
  | [] -> ""
  | '[' :: c_list -> "Branch (Seq [" ^ compl_axiom c_list
  | ']' :: c_list -> "]);" ^ compl_axiom c_list
  | c :: c_list -> "Symb '" ^ (String.make 1 c) ^ "';" ^ compl_axiom c_list;;
  
(*
Author -> Hugo
Version -> 1.0
Recursive -> internal
Description -> Convert the raw rules into a char Systems.word
Param -> c_list : A char list
Return -> A string 
*)
let compl_rule c_list =
  let rec browse c_list =
    match c_list with
    | [] -> ""
    | '[' :: c_list -> "Branch (Seq [" ^ browse c_list
    | ']' :: c_list -> "]);" ^ browse c_list
    | c :: c_list -> "Symb '" ^ (String.make 1 c) ^ "';" ^ browse c_list in
  "Seq [" ^ browse c_list;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> internal
Description -> Convert the raw interpretation into a char Systems.word
Param -> c_list : A char list
Return -> A string 
*)
let compl_itpr c_list =
  let rec browse c_list =
    match c_list with
    | [] -> ""
    | c :: c_list -> (String.make 1 c) ^ browse c_list in
  let traduction = trad_itpr (hd c_list) in
  let c_list = tl c_list in
  if traduction = "" then invalid_arguments "Invalid format\n" else ();
  let traduction = traduction ^ (browse c_list) in
  if String.contains traduction ']' then traduction else traduction ^ ")]";;

(*
Author -> Hugo
Version -> 1.0
Recursive -> yes
Description -> Convert the raw list into a part of a function
Param -> c_list : A char list
Param -> compl : The function to be applied on the list
Return -> A string 
*)
let expand c_list compl =
  let traduction = "'" ^ (String.make 1 (hd c_list)) ^ "' -> " in
  let c_list = tl (tl c_list) in
  traduction ^ (compl c_list);;

(*
Author -> Hugo
Version -> 1.0
Recursive -> internal
Description -> Convert the raw axiom into his string representation
Param -> axiom : A string list (one element) representing the axiom
Return -> A string 
*)
let axiom_to_str axiom =
  let rec browse axiom =
    match axiom with
    | [] -> "];\n"
    | s :: axiom -> (compl_axiom (explode s)) ^ browse axiom in
  "  axiom = Seq [" ^ browse axiom;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> internal
Description -> Convert the raw rules into their string representation
Param -> rules : A string list representing the rules
Return -> A string 
*)
let rules_to_str rules =
  let rec browse rules =
    match rules with
    | [] -> "]\n    | s -> Symb s);\n"
    | s :: rules ->
      "\n    | " ^ (expand (explode s) compl_rule) ^ browse rules in
  "  rules =\n    (function" ^ browse rules;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> internal
Description -> Convert the raw interp into his string representation
Param -> axiom : A string list (one element) representing the axiom
Return -> A string 
*)
let interp_to_str interp =
  let rec browse interp =
    match interp with
    | [] -> "\n    | _ -> [])\n};;\n"
    | s :: interp -> 
      "\n    | " ^ (expand (explode s) compl_itpr) ^ browse interp in
  "  interp =\n    (function" ^ browse interp;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Create the lsys.ml and lsys.mli files and fill them
Param -> res : The content to be written in the lsys.ml
*)
let create_sys_out res =
  if Sys.file_exists "lsys.ml" then Sys.remove "lsys.ml" else ();
  let fd = open_out "lsys.ml" in
  output_string fd res;
  close_out fd;
  let fd = open_out "lsys.mli" in
  output_string fd "open Systems\n\nval lsys : char system\n";
  close_out fd;;

(*
Author -> Hugo
Version -> 1.0
Recursive -> no
Description -> Parse the file specified in the arguments 
               and fill the lsys.ml with the traduction in char Systems.word
Param -> argv : The arguments array (I promise it's the only impure part)
*)
let construct_lsys argv =
  if not (Array.length argv = 2) then 
  invalid_arguments "usage: ./run [lsys_description_file]\n" 
  else if not (Sys.file_exists argv.(1)) then 
  invalid_arguments "File does not exists\n" else ();
  let fd = open_in argv.(1) in
  let axiom = get_next fd false [] in
  let rules = get_next fd false [] in
  let interp = get_next fd false [] in
  close_in fd;
  if axiom = [] || rules = [] || interp = [] then
  invalid_arguments "Invalid format\n" else ();
  let res = "open Systems\n\nlet lsys : char system = {\n" in
  let res = res ^ axiom_to_str axiom in
  let res = res ^ rules_to_str rules ^ interp_to_str interp in
  create_sys_out res;;
