print_string "Hello, December 15th part II\n"

(* let input = [|0; 3; 6|];; *)
let input = [|1;0;16;5;17;4|]
let seen : (int, int) Hashtbl.t = Hashtbl.create 436;;

let setValue idx prev elem =
  (* Printf.printf "turn %d  set elem: %d prev: %d new: %d\n" (idx+1) elem prev (idx - prev); *)
  Hashtbl.replace seen elem idx;
  idx - prev

let calc idx elem =
  try
    let lastSeen = Hashtbl.find seen elem in
      setValue idx lastSeen elem
  with Not_found -> setValue idx idx elem;;

let rec process i max last = 
  (* elements from the initial input should just return themselves *)
  if i < Array.length input then (Hashtbl.add seen input.(i) i; process (i+1) max last)
  else if i >= max then last
  else process (i+1) max (calc i last);;

Printf.printf "%d\n" (process 0 (30000000-1) 0)