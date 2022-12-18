type t =
  | CUSTOM
  | DELPHINET
  | EDONET
  | FLORENCENET
  | GRANADANET
  | HANGZHOUNET
  | ITHACANET
  | JAKARTANET
  | KATHMANDUNET
  | DAILYNET
  | MONDAYNET
  | GHOSTNET
  | MAINNET

let to_string = function
  | CUSTOM -> "custom"
  | DELPHINET -> "delphinet"
  | EDONET -> "edonet"
  | FLORENCENET -> "florencenet"
  | GRANADANET -> "granadanet"
  | HANGZHOUNET -> "hangzhounet"
  | ITHACANET -> "ithacanet"
  | JAKARTANET -> "jakartanet"
  | KATHMANDUNET -> "kathmandunet"
  | DAILYNET -> "dailynet"
  | MONDAYNET -> "mondaynet"
  | GHOSTNET -> "ghostnet"
  | MAINNET -> "mainnet"

let from_string str =
  match String.(trim (lowercase_ascii str)) with
  | "delphinet" -> DELPHINET
  | "edonet" -> EDONET
  | "florencenet" -> FLORENCENET
  | "granadanet" -> GRANADANET
  | "hangzhounet" -> HANGZHOUNET
  | "ithacanet" -> ITHACANET
  | "jakartanet" -> JAKARTANET
  | "kathmandunet" -> KATHMANDUNET
  | "dailynet" -> DAILYNET
  | "mondaynet" -> MONDAYNET
  | "ghostnet" -> GHOSTNET
  | "mainnet" -> MAINNET
  | _ -> CUSTOM
