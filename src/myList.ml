(*
MIT License

Copyright (c) 2017 by John Wickerson.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

(** Extension to the List module *)

open! Format
open! General_purpose
open List
  
let exists_pair f xs ys =
  exists (fun x -> exists (f x) ys) xs

let the = function
  | [x] -> x
  | _ -> raise Not_found

let rec pp_gen s f oc = function
  | [] -> ()
  | [x] -> f oc x
  | x :: xs -> f oc x; fprintf oc "%s" s; pp_gen s f oc xs

let pp f oc xs =
  let rec pp = function
    | [] -> ()
    | [x] -> f oc x
    | x :: xs -> f oc x; fprintf oc "; "; pp xs
  in
  fprintf oc "["; pp xs; fprintf oc "]"
						 
let filteri p xs =
  let helper (n,acc) x =
    let n' = n + 1 in
    if p n x then (n', acc @ [x]) else (n', acc)
  in
  let _, xs' = (List.fold_left helper (0,[]) xs) in
  xs'

(** [foreach xs f] executes [f] on each element of [xs] *)
let foreach xs f = List.iter f xs

(** [max xs] returns the largest element of [xs]. Assumes [xs] is non-empty. *)
let max xs =
  hd (rev (sort compare xs))

(** [take p xs] returns the largest prefix of [xs] all of whose elements satisfy [p] *)
let rec take p = function
  | [] -> []
  | x::xs -> if p x then x::(take p xs) else []

(** [drop n xs] removes the first [n] elements from [xs] *)
let rec drop n xs =
  if n = 0 then xs
  else drop (n-1) (List.tl xs)

(** [insert_all_positions 1 [2;3]] gives [[[1;2;3]; [2;1;3]; [2;3;1]]] *)
let rec insert_all_positions x = function
  | [] -> [[x]]
  | hd::tl -> (x::hd::tl) :: (map (fun y -> hd::y) (insert_all_positions x tl))

(** [perms [1;2;3]] gives [[[1;2;3]; [2;1;3]; [2;3;1]; [1;3;2]; [3;1;2]; [3;2;1]]] *)
let rec perms = function
  | [] -> [[]]
  | hd::tl -> concat (map (insert_all_positions hd) (perms tl))

(** [insert_all_sorted_positions cmp y xs] returns all lists obtained by inserting [y] into the sorted list [xs] in a position that keeps the list sorted (according to comparator [cmp]). We assume that [y] is no larger than any element in [xs]. Example: [insert_all_sorted_positions compare_by_length "a" ["";"b";"cd"]] gives [[["";"a";"b";"cd"]; ["";"b";"a";"cd"]]]. *)
let insert_all_sorted_positions cmp y xs =
  let rec insert_all_sorted_positions = function
    | [] -> [[y]]
    | x::xs when cmp y x = -1 -> [y::x::xs]
    | x::xs -> (y::x::xs) :: map (cons x) (insert_all_sorted_positions xs)
  in insert_all_sorted_positions xs

(** [lin_extns cmp xs] returns all lists obtained by permuting the sorted list [xs] while keeping it sorted (according to comparator [cmp]). Example: [lin_extns compare_by_length ["";"a";"b";"cd"]] gives [[["";"a";"b";"cd"]; [""; "b";"a";"cd"]]]. *)
let lin_extns cmp xs =
  let rec lin_extns = function
    | [] -> [[]]
    | hd::tl -> concat (map (insert_all_sorted_positions cmp hd) (lin_extns tl))
  in lin_extns xs

(** [cartesian xs ys] returns the list of all pairs [(x,y)] where [x] is in [xs] and [y] is in [ys] *)
let cartesian xs ys =
  List.concat (List.map (fun x -> List.map (fun y -> (x,y)) ys) xs)

(** [n_cartesian [l1;...;ln]] returns the list of all lists of the form [[x1;...;xn]] where [xi] is in [li] for all [1 <= i <= n]. Example: [n_cartesian [[1;2];[3];[4;5]]] gives [[[1; 3; 4]; [1; 3; 5]; [2; 3; 4]; [2; 3; 5]]]. *)
let rec n_cartesian = function
  | [] -> [[]]
  | xs::xss -> concat (map (fun x -> List.map (cons x) (n_cartesian xss)) xs)

(** [remove_dupes xs] removes duplicated elements from [xs]. *)
let rec remove_dupes = function
| [] -> []
| x::xs -> x :: remove_dupes (filter ((<>) x) xs)
