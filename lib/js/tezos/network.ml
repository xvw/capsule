type type_ =
  | CUSTOM
  | DELPHINET
  | EDONET
  | FLORENCENET
  | GRANADANET
  | HANGZHOUNET
  | ITHACANET
  | JAKARTANET
  | KATHMANDUNET
  | LIMANET
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
  | LIMANET -> "limanet"
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
  | "limanet" -> LIMANET
  | "dailynet" -> DAILYNET
  | "mondaynet" -> MONDAYNET
  | "ghostnet" -> GHOSTNET
  | "mainnet" -> MAINNET
  | _ -> CUSTOM

type t = { name : string; rpc_url : string; type_ : type_ }

let base_path { rpc_url; _ } = "https://" ^ rpc_url
let make type_ name rpc_url = { name; rpc_url; type_ }

module Nodes = struct
  module Mainnet = struct
    let make name = make MAINNET (name ^ " mainnet")
    let marigold = make "marigold" "mainnet.tezos.marigold.dev"
    let ecadlabs = make "ECAD Labs" "mainnet.api.tez.ie"
    let smartpy = make "SmartPy" "mainnet.smartpy.io"
    let tezos_foundation = make "Tezos Foundation" "rpc.tzbeta.net"
    let teztools = make "TezTools" "eu01-node.teztools.net"
    let make ~name ~rpc_url = make name rpc_url
  end
end
