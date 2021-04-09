open Systems;;

val invalid_arguments : string -> unit

val get_next : in_channel -> bool -> string list -> string list

val construct_lsys : string array -> unit
