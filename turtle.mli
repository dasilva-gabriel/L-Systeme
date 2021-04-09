open Graphics

(** Turtle graphical commands *)
type command =
  | Line of int      (** advance turtle while drawing *)
  | Move of int      (** advance without drawing *)
  | Turn of int      (** turn turtle by n degrees *)
  | Store            (** save the current position of the turtle *)
  | Restore          (** restore the last saved position not yet restored *)
  
  (** Position and angle of the turtle *)
  type position = {
    x: float;        (** position x *)
    y: float;        (** position y *)
    a: int;          (** angle of the direction *)
  }
  
  (** Put here any type and function signatures concerning turtle *)

val exec : command list -> position -> position Stack.t -> color Stack.t -> int -> unit