class ['a] olist_1 (l : 'a list) =
  object
    val value = l
    method length = List.length l
    method append other = {<value = List.append value other>}
    method map : 'b. ('a -> 'b) -> 'b list = fun f -> List.map f value
  end

class ['a] olist_2 (l : 'a list) =
  object
    val value = l
    method length = List.length l
    method append other = {<value = List.append value other>}

    method map : 'b. ('a -> 'b) -> 'b olist_1 =
      fun f -> new olist_1 (List.map f value)
  end

(* class ['a] olist_3 (l : 'a list) = *)
(*   object (self) *)
(*     val value = l *)
(*     method length = List.length l *)
(*     method append other = {<value = List.append value other>} *)
(*     method map : 'b. ('a -> 'b) -> 'b olist_3 = new self (List.map f value) *)
(*   end *)

type (_, _) eq = Refl : ('a, 'a) eq

(* class ['a] olist_4 (l : 'a list) = *)
(*   object *)
(*     val value = l *)
(*     method to_list = l *)
(*     method length = List.length l *)
(*     method append other = {<value = List.append value other>} *)

(*     method flatten : 'b. ('a, 'b list) eq -> 'b list = *)
(*       fun Refl -> List.flatten l *)
(*   end *)

(* let c = new olist_4 [ [ 1 ]; [ 2 ]; [ 3 ] ] *)

class type ['a] clist =
  object ('self)
    method length : int
    method uncons : ('a * 'self) option
    method concat : 'a clist -> 'a clist
    method flatten : ('a, 'b list) eq -> 'b list
  end

let olist l =
  let rec flatten : type a b. (a, b list) eq -> a #clist -> b list =
   fun eq l ->
    match l#uncons with
    | None -> []
    | Some (pa, x) ->
        let a : b list =
          let Refl = eq in
          pa
        in
        a @ flatten eq x
  in
  object (self : 'a clist)
    val inner = l
    method length = List.length inner

    method uncons : ('a * 'a clist) option =
      match inner with [] -> None | a :: q -> Some (a, {<inner = q>})

    method concat (_ : 'a clist) = assert false
    method flatten : 'b. ('a, 'b list) eq -> 'b list = fun eq -> flatten eq self
  end

module O = struct
  class type ['a] obj_list =
    object ('self)
      method length : int
      method append : 'a list -> 'a obj_list
      method uncons : ('a * 'self) option
      method sum : ('a, int) eq -> int
      method flatten : ('a, 'b list) eq -> 'b list
    end

  let my_list (list : 'a list) =
    object (self : 'a #obj_list)
      val l = list
      method length = List.length l
      method append x = {<l = List.append l x>}
      method uncons = match l with [] -> None | x :: xs -> Some (x, {<l = xs>})

      method sum =
        let aux : type a. a list -> (a, int) eq -> int =
         fun list Refl -> List.fold_left (fun acc x -> acc + x) 0 list
        in
        aux l

      method flatten : 'b. ('a, 'b list) eq -> 'b list =
        let rec aux : type a b. a #obj_list -> (a, b list) eq -> b list =
         fun list witness ->
          match list#uncons with
          | None -> []
          | Some (head_list, xs) ->
              let flatten_list : b list =
                let Refl = witness in
                head_list
              in
              flatten_list @ aux xs witness
        in
        aux self
    end
end

let b = O.my_list [ [ 1 ]; [ 2 ]; [ 3 ] ]
let c = b#flatten Refl
let _ = assert ([ 1; 2; 3 ] = c)
let d = (O.my_list c)#sum Refl
let _ = assert (6 = d)

type other_int = int

let (_ : (int, other_int) eq) = Refl

module Age : sig
  type t

  val eq : (int, t) eq
  val make : int -> (t, string) result
end = struct
  type t = int

  let eq = Refl

  let make x =
    if x < 0 then Error "age trop petit"
    else if x > 150 then Error "age trop grand"
    else Ok x
end

let e = Age.eq

open O

let a = my_list [ [ 1 ]; [ 2 ]; [ 3 ] ]
let _ = assert ([ 1; 2; 3 ] = a#flatten Refl)
let b = my_list [ 1; 2; 3; 4 ]
let _ = assert (10 = b#sum Refl)
(* let _ = a#sum Refl *)
