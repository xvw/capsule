module Directory = struct
  open Path

  let get_chain () = ~/:chain_id
  let get_block () = ~:get_chain /: block_id
  let get_context () = ~:get_block / "context"
  let get_contract () = ~:get_context /: contract_id
  let get_balance () = ~:get_contract / "balance"
end

let get_balance () = Entrypoint.get ~path:Directory.get_balance Data_encoding.z
