type t = { dapp_client : DApp_client.t; network : Tezos_js.Network.t }

let make ?icon_url ?app_url ~network ~name () =
  let matrix_nodes = [ network.Tezos_js.Network.rpc_url ]
  and preferred_network = network.Tezos_js.Network.type_ in
  let dapp_client =
    DApp_client.make ?icon_url ?app_url ~matrix_nodes ~preferred_network ~name
      ()
  in
  { dapp_client; network }

let request_permissions ?scopes { dapp_client; network } =
  let network = Network.from_tezos_network network in
  DApp_client.request_permissions ~network ?scopes dapp_client

let get_active_account { dapp_client; _ } =
  DApp_client.get_active_account dapp_client

let clear_active_account { dapp_client; _ } =
  DApp_client.clear_active_account dapp_client

let disconnect_client client = clear_active_account client

let get_block_explorer { dapp_client; _ } =
  DApp_client.get_block_explorer dapp_client

let rpc_call ~client:{ network; _ } ~entrypoint =
  Tezos_js.RPC.make_call ~network ~entrypoint

let rpc_call_head ~client:{ network; _ } ~entrypoint =
  Tezos_js.RPC.make_call_head ~network ~entrypoint

let rpc_reachable_call ~client:{ network; _ } ~entrypoint =
  Tezos_js.RPC.is_reachable ~network ~entrypoint

let rpc_reachable_call_head ~client:{ network; _ } ~entrypoint =
  Tezos_js.RPC.is_reachable_head ~network ~entrypoint

let rpc_stream ?retention_policy ~client:{ network; _ } ~entrypoint ~on_chunk =
  Tezos_js.RPC.make_stream ?retention_policy ~network ~entrypoint ~on_chunk
