include Gen.Preface_optional (struct
  type 'a t = 'a option

  let empty = None
  let return x = Some x
  let fold n s = function None -> n () | Some x -> s x

  let pp pp' formater = function
    | None -> Format.fprintf formater "None"
    | Some x -> Format.fprintf formater "@[<2>Some@ @[%a@]@]" pp' x
end)
