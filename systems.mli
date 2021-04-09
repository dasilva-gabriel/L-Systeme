open Graphics

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

(** Put here any type and function interfaces concerning systems *)

val next_step : 's system -> Turtle.position -> Turtle.position Stack.t -> color Stack.t -> int -> unit 