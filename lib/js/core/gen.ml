open Js_of_ocaml

module Preface_syntax
    (F : Preface.Specs.FUNCTOR)
    (A : Preface.Specs.APPLICATIVE with type 'a t = 'a F.t)
    (M : Preface.Specs.MONAD with type 'a t = 'a F.t) =
struct
  module Syntax = struct
    type 'a t = 'a F.t

    let ( let+ ) x f = F.map f x
    let ( and+ ) = A.Syntax.( and+ )
    let ( let* ) = M.Syntax.( let* )
  end

  include Syntax
end

module Preface_infix
    (F : Preface.Specs.FUNCTOR)
    (A : Preface.Specs.APPLICATIVE with type 'a t = 'a F.t)
    (P : Preface.Specs.ALTERNATIVE with type 'a t = 'a F.t)
    (S : Preface.Specs.SELECTIVE with type 'a t = 'a F.t)
    (M : Preface.Specs.MONAD with type 'a t = 'a F.t) =
struct
  module Infix = struct
    type 'a t = 'a F.t

    let ( <$> ), ( <&> ), ( <$ ), ( $> ) =
      F.Infix.(( <$> ), ( <&> ), ( <$ ), ( $> ))

    let ( <*> ), ( <**> ), ( *> ), ( <* ) =
      A.Infix.(( <*> ), ( <**> ), ( *> ), ( <* ))

    let ( <|> ) = P.Infix.( <|> )
    let ( <*? ), ( <||> ), ( <&&> ) = S.Infix.(( <*? ), ( <||> ), ( <&&> ))

    let ( =|< ), ( >|= ), ( >>= ), ( =<< ), ( >=> ), ( <=< ), ( >> ), ( << ) =
      M.Infix.
        (( =|< ), ( >|= ), ( >>= ), ( =<< ), ( >=> ), ( <=< ), ( >> ), ( << ))
  end

  include Infix
end

module Preface_optional (R : Interfaces.OPTIONAL_REQ) = struct
  include R

  let stop () = empty

  let equal f left right =
    fold
      (fun () -> fold (fun () -> true) (fun _ -> false) right)
      (fun left -> fold (fun () -> false) (f left) right)
      left

  let test x = fold (fun () -> false) (fun _ -> true) x
  let value ~default x = fold (fun () -> default) (fun x -> x) x
  let if_ p x = if p x then return x else empty
  let unless p x = if p x then empty else return x
  let to_list x = fold (fun () -> []) (fun x -> [ x ]) x
  let to_option x = fold (fun () -> None) Option.some x
  let from_option = function Some x -> return x | None -> empty
  let to_nullable x = fold (fun () -> Js.Opt.empty) Js.Opt.return x
  let from_nullable x = Js.Opt.case x (fun () -> empty) return
  let to_undefinedable x = fold (fun () -> Js.Optdef.empty) Js.Optdef.return x
  let from_undefinedable x = Js.Optdef.case x (fun () -> empty) return

  let traverse_aux return_r map f =
    fold (fun () -> return_r empty) (fun x -> map return (f x))

  module Functor = Preface.Make.Functor.Via_map (struct
    type nonrec 'a t = 'a t

    let map f x = fold stop (fun x -> return (f x)) x
  end)

  module Alt =
    Preface.Make.Alt.Over_functor
      (Functor)
      (struct
        type nonrec 'a t = 'a t

        let combine l r = fold (fun () -> r) (fun x -> return x) l
      end)

  module Alternative = Preface.Make.Alternative.Via_pure_and_apply (struct
    type nonrec 'a t = 'a t

    let pure = return

    let apply fs xs =
      fold stop (fun f -> fold stop (fun x -> return (f x)) xs) fs

    let neutral = empty
    let combine = Alt.combine
  end)

  module Applicative =
    Preface.Make.Traversable.Join_with_applicative
      (Alternative)
      (functor
         (Applicative : Preface.Specs.APPLICATIVE)
         ->
         Preface.Make.Traversable.Over_applicative
           (Applicative)
           (struct
             type 'a iter = 'a t
             type 'a t = 'a Applicative.t

             let traverse f x =
               traverse_aux Applicative.pure Applicative.map f x
           end))

  module Monad_plus = Preface.Make.Monad_plus.Via_bind (struct
    type nonrec 'a t = 'a t

    let return = return
    let bind f x = fold stop f x
    let neutral = Alternative.neutral
    let combine = Alternative.combine
  end)

  module Monad =
    Preface.Make.Traversable.Join_with_monad
      (Monad_plus)
      (functor
         (Monad : Preface.Specs.MONAD)
         ->
         Preface.Make.Traversable.Over_monad
           (Monad)
           (struct
             type 'a iter = 'a t
             type 'a t = 'a Monad.t

             let traverse f x = traverse_aux Monad.return Monad.map f x
           end))

  module Selective =
    Preface.Make.Selective.Over_applicative_via_select
      (Applicative)
      (Preface.Make.Selective.Select_from_monad (Monad))

  module Foldable = Preface.Make.Foldable.Via_fold_right (struct
    type nonrec 'a t = 'a t

    let fold_right f x acc = fold (fun () -> acc) (fun v -> f v acc) x
  end)

  include Preface_syntax (Functor) (Applicative) (Monad)

  include
    Preface_infix (Functor) (Applicative) (Alternative) (Selective) (Monad)
end
