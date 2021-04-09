open Systems

let lsys : char system = {
  axiom = Seq [Symb 'A';];
  rules =
    (function
    | 'A' -> Seq [Symb 'A';Branch (Seq [Symb 'P';Symb 'A';]);Symb 'A';Branch (Seq [Symb 'M';Symb 'A';]);Symb 'A';]
    | s -> Symb s);
  interp =
    (function
    | 'M' -> [Turn (-25)]
    | 'P' -> [Turn (25)]
    | 'A' -> [Line (100)]
    | _ -> [])
};;
