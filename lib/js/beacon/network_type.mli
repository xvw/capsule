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

val to_string : t -> string
val from_string : string -> t
