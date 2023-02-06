open Js_of_ocaml.Js

include Gen.Preface_optional (struct
  type 'a t = 'a Optdef.t

  let empty = Optdef.empty
  let return x = Optdef.return x
  let fold n s x = Optdef.case x n s

  let pp pp' formater x =
    fold
      (fun () -> Format.fprintf formater "Js.undefined")
      (fun x -> Format.fprintf formater "@[<2>Js.defined@ @[%a@]@]" pp' x)
      x
end)
