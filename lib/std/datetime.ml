let compare_from_opt f previous current =
  match previous with
  | None -> Some current
  | Some previous -> Some (f previous current)
;;

let min_opt = compare_from_opt Yocaml.Datetime.min
let max_opt = compare_from_opt Yocaml.Datetime.max

let normalize_month Yocaml.Datetime.{ month; _ } =
  Yocaml.Data.string
    (match month with
     | Jan -> "Janvier"
     | Feb -> "Février"
     | Mar -> "Mars"
     | Apr -> "Avril"
     | May -> "Mai"
     | Jun -> "Juin"
     | Jul -> "Juillet"
     | Aug -> "Août"
     | Sep -> "Septembre"
     | Oct -> "Octobre"
     | Nov -> "Novembre"
     | Dec -> "Décembre")
;;
