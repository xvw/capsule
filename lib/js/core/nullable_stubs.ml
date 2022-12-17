open Js_of_ocaml.Js

include Gen.Preface_optional (struct
  type 'a t = 'a Opt.t

  let empty = Opt.empty
  let return x = Opt.return x
  let fold n s x = Opt.case x n s

  let pp pp' formater x =
    fold
      (fun () -> Format.fprintf formater "Js.null")
      (fun x -> Format.fprintf formater "@[<2>Js.not_null@ @[%a@]@]" pp' x)
      x
end)
