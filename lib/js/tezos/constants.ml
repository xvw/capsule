type dal_parametric = {
    availability_threshold : int
  ; endorsement_lag : int
  ; feature_enable : bool
  ; number_of_shards : int
  ; number_of_slots : int
  ; page_size : int
  ; redundancy_factor : int
  ; slot_size : int
}

let dal_parametric_encoding =
  let open Data_encoding in
  conv
    (fun {
           availability_threshold
         ; endorsement_lag
         ; feature_enable
         ; number_of_shards
         ; number_of_slots
         ; page_size
         ; redundancy_factor
         ; slot_size
         } ->
      ( availability_threshold
      , endorsement_lag
      , feature_enable
      , number_of_shards
      , number_of_slots
      , page_size
      , redundancy_factor
      , slot_size ))
    (fun ( availability_threshold
         , endorsement_lag
         , feature_enable
         , number_of_shards
         , number_of_slots
         , page_size
         , redundancy_factor
         , slot_size ) ->
      {
        availability_threshold
      ; endorsement_lag
      ; feature_enable
      ; number_of_shards
      ; number_of_slots
      ; page_size
      ; redundancy_factor
      ; slot_size
      })
    (obj8
       (req "availability_threshold" int31)
       (req "endorsement_lag" int31)
       (req "feature_enable" bool)
       (req "number_of_shards" int31)
       (req "number_of_slots" int31)
       (req "page_size" int31)
       (req "redundancy_factor" int31)
       (req "slot_size" int31))

type fraction = { denominator : int; numerator : int }

let fraction_encoding =
  let open Data_encoding in
  conv
    (fun { denominator; numerator } -> (denominator, numerator))
    (fun (denominator, numerator) -> { denominator; numerator })
    (obj2 (req "denominator" int31) (req "numerator" int31))

type t = {
    baking_reward_bonus_per_slot : Z.t
  ; baking_reward_fixed_portion : Z.t
  ; blocks_per_commitment : int
  ; blocks_per_cycle : int
  ; blocks_per_stake_snapshot : int
  ; cache_layout_size : int
  ; cache_sampler_state_cycles : int
  ; cache_script_size : int
  ; cache_stake_distribution_cycles : int
  ; consensus_committee_size : int
  ; consensus_threshold : int
  ; cost_per_byte : Z.t
  ; cycles_per_voting_period : int
  ; dal_parametric : dal_parametric
  ; delay_increment_per_round : Z.t
  ; double_baking_punishment : Z.t
  ; endorsing_reward_per_slot : Z.t
  ; frozen_deposits_percentage : int
  ; hard_gas_limit_per_block : Z.t
  ; hard_gas_limit_per_operation : Z.t
  ; hard_storage_limit_per_operation : Z.t
  ; liquidity_baking_subsidy : Z.t
  ; liquidity_baking_toggle_ema_threshold : int64
  ; max_allowed_global_constants_depth : int
  ; max_anon_ops_per_block : int
  ; max_micheline_bytes_limit : int
  ; max_micheline_node_count : int
  ; max_operation_data_length : int
  ; max_operations_time_to_live : int
  ; max_proposals_per_delegate : int
  ; max_slashing_period : int
  ; michelson_maximum_type_size : int
  ; min_proposal_quorum : int
  ; minimal_block_delay : Z.t
  ; minimal_participation_ratio : fraction
  ; minimal_stake : Z.t
  ; nonce_length : int
  ; nonce_revelation_threshold : int
  ; origination_size : int
  ; preserved_cycles : int
  ; proof_of_work_nonce_size : int
  ; proof_of_work_threshold : Z.t
  ; quorum_max : int
  ; quorum_min : int
  ; ratio_of_frozen_deposits_slashed_per_double_endorsement : fraction
  ; sc_max_wrapped_proof_binary_size : int
  ; sc_rollup_challenge_window_in_blocks : int
  ; sc_rollup_commitment_period_in_blocks : int
  ; sc_rollup_enable : bool
  ; sc_rollup_max_active_outbox_levels : int
  ; sc_rollup_max_lookahead_in_blocks : int
  ; sc_rollup_max_number_of_cemented_commitments : int
  ; sc_rollup_max_number_of_messages_per_commitment_period : Int64.t
  ; sc_rollup_max_outbox_messages_per_level : int
  ; sc_rollup_message_size_limit : int
  ; sc_rollup_number_of_sections_in_dissection : int
  ; sc_rollup_origination_size : int
  ; sc_rollup_stake_amount : Z.t
  ; sc_rollup_timeout_period_in_blocks : int
  ; seed_nonce_revelation_tip : Z.t
  ; tx_rollup_commitment_bond : Z.t
  ; tx_rollup_cost_per_byte_ema_factor : int
  ; tx_rollup_enable : bool
  ; tx_rollup_finality_period : int
  ; tx_rollup_hard_size_limit_per_inbox : int
  ; tx_rollup_hard_size_limit_per_message : int
  ; tx_rollup_max_commitments_count : int
  ; tx_rollup_max_inboxes_count : int
  ; tx_rollup_max_messages_per_inbox : int
  ; tx_rollup_max_ticket_payload_size : int
  ; tx_rollup_max_withdrawals_per_batch : int
  ; tx_rollup_origination_size : int
  ; tx_rollup_rejection_max_proof_size : int
  ; tx_rollup_sunset_level : int
  ; tx_rollup_withdraw_period : int
  ; vdf_difficulty : Z.t
  ; zk_rollup_enable : bool
  ; zk_rollup_min_pending_to_process : int
  ; zk_rollup_origination_size : int
}

let inj
    {
      baking_reward_bonus_per_slot
    ; baking_reward_fixed_portion
    ; blocks_per_commitment
    ; blocks_per_cycle
    ; blocks_per_stake_snapshot
    ; cache_layout_size
    ; cache_sampler_state_cycles
    ; cache_script_size
    ; cache_stake_distribution_cycles
    ; consensus_committee_size
    ; consensus_threshold
    ; cost_per_byte
    ; cycles_per_voting_period
    ; dal_parametric
    ; delay_increment_per_round
    ; double_baking_punishment
    ; endorsing_reward_per_slot
    ; frozen_deposits_percentage
    ; hard_gas_limit_per_block
    ; hard_gas_limit_per_operation
    ; hard_storage_limit_per_operation
    ; liquidity_baking_subsidy
    ; liquidity_baking_toggle_ema_threshold
    ; max_allowed_global_constants_depth
    ; max_anon_ops_per_block
    ; max_micheline_bytes_limit
    ; max_micheline_node_count
    ; max_operation_data_length
    ; max_operations_time_to_live
    ; max_proposals_per_delegate
    ; max_slashing_period
    ; michelson_maximum_type_size
    ; min_proposal_quorum
    ; minimal_block_delay
    ; minimal_participation_ratio
    ; minimal_stake
    ; nonce_length
    ; nonce_revelation_threshold
    ; origination_size
    ; preserved_cycles
    ; proof_of_work_nonce_size
    ; proof_of_work_threshold
    ; quorum_max
    ; quorum_min
    ; ratio_of_frozen_deposits_slashed_per_double_endorsement
    ; sc_max_wrapped_proof_binary_size
    ; sc_rollup_challenge_window_in_blocks
    ; sc_rollup_commitment_period_in_blocks
    ; sc_rollup_enable
    ; sc_rollup_max_active_outbox_levels
    ; sc_rollup_max_lookahead_in_blocks
    ; sc_rollup_max_number_of_cemented_commitments
    ; sc_rollup_max_number_of_messages_per_commitment_period
    ; sc_rollup_max_outbox_messages_per_level
    ; sc_rollup_message_size_limit
    ; sc_rollup_number_of_sections_in_dissection
    ; sc_rollup_origination_size
    ; sc_rollup_stake_amount
    ; sc_rollup_timeout_period_in_blocks
    ; seed_nonce_revelation_tip
    ; tx_rollup_commitment_bond
    ; tx_rollup_cost_per_byte_ema_factor
    ; tx_rollup_enable
    ; tx_rollup_finality_period
    ; tx_rollup_hard_size_limit_per_inbox
    ; tx_rollup_hard_size_limit_per_message
    ; tx_rollup_max_commitments_count
    ; tx_rollup_max_inboxes_count
    ; tx_rollup_max_messages_per_inbox
    ; tx_rollup_max_ticket_payload_size
    ; tx_rollup_max_withdrawals_per_batch
    ; tx_rollup_origination_size
    ; tx_rollup_rejection_max_proof_size
    ; tx_rollup_sunset_level
    ; tx_rollup_withdraw_period
    ; vdf_difficulty
    ; zk_rollup_enable
    ; zk_rollup_min_pending_to_process
    ; zk_rollup_origination_size
    } =
  ( ( baking_reward_bonus_per_slot
    , baking_reward_fixed_portion
    , blocks_per_commitment
    , blocks_per_cycle
    , blocks_per_stake_snapshot
    , cache_layout_size
    , cache_sampler_state_cycles
    , cache_script_size
    , cache_stake_distribution_cycles
    , consensus_committee_size )
  , ( consensus_threshold
    , cost_per_byte
    , cycles_per_voting_period
    , dal_parametric
    , delay_increment_per_round
    , double_baking_punishment
    , endorsing_reward_per_slot
    , frozen_deposits_percentage
    , hard_gas_limit_per_block
    , hard_gas_limit_per_operation )
  , ( hard_storage_limit_per_operation
    , liquidity_baking_subsidy
    , liquidity_baking_toggle_ema_threshold
    , max_allowed_global_constants_depth
    , max_anon_ops_per_block
    , max_micheline_bytes_limit
    , max_micheline_node_count
    , max_operation_data_length
    , max_operations_time_to_live
    , max_proposals_per_delegate )
  , ( max_slashing_period
    , michelson_maximum_type_size
    , min_proposal_quorum
    , minimal_block_delay
    , minimal_participation_ratio
    , minimal_stake
    , nonce_length
    , nonce_revelation_threshold
    , origination_size
    , preserved_cycles )
  , ( proof_of_work_nonce_size
    , proof_of_work_threshold
    , quorum_max
    , quorum_min
    , ratio_of_frozen_deposits_slashed_per_double_endorsement
    , sc_max_wrapped_proof_binary_size
    , sc_rollup_challenge_window_in_blocks
    , sc_rollup_commitment_period_in_blocks
    , sc_rollup_enable
    , sc_rollup_max_active_outbox_levels )
  , ( sc_rollup_max_lookahead_in_blocks
    , sc_rollup_max_number_of_cemented_commitments
    , sc_rollup_max_number_of_messages_per_commitment_period
    , sc_rollup_max_outbox_messages_per_level
    , sc_rollup_message_size_limit
    , sc_rollup_number_of_sections_in_dissection
    , sc_rollup_origination_size
    , sc_rollup_stake_amount
    , sc_rollup_timeout_period_in_blocks
    , seed_nonce_revelation_tip )
  , ( tx_rollup_commitment_bond
    , tx_rollup_cost_per_byte_ema_factor
    , tx_rollup_enable
    , tx_rollup_finality_period
    , tx_rollup_hard_size_limit_per_inbox
    , tx_rollup_hard_size_limit_per_message
    , tx_rollup_max_commitments_count
    , tx_rollup_max_inboxes_count
    , tx_rollup_max_messages_per_inbox
    , tx_rollup_max_ticket_payload_size )
  , ( tx_rollup_max_withdrawals_per_batch
    , tx_rollup_origination_size
    , tx_rollup_rejection_max_proof_size
    , tx_rollup_sunset_level
    , tx_rollup_withdraw_period
    , vdf_difficulty
    , zk_rollup_enable
    , zk_rollup_min_pending_to_process
    , zk_rollup_origination_size ) )

let proj
    ( ( baking_reward_bonus_per_slot
      , baking_reward_fixed_portion
      , blocks_per_commitment
      , blocks_per_cycle
      , blocks_per_stake_snapshot
      , cache_layout_size
      , cache_sampler_state_cycles
      , cache_script_size
      , cache_stake_distribution_cycles
      , consensus_committee_size )
    , ( consensus_threshold
      , cost_per_byte
      , cycles_per_voting_period
      , dal_parametric
      , delay_increment_per_round
      , double_baking_punishment
      , endorsing_reward_per_slot
      , frozen_deposits_percentage
      , hard_gas_limit_per_block
      , hard_gas_limit_per_operation )
    , ( hard_storage_limit_per_operation
      , liquidity_baking_subsidy
      , liquidity_baking_toggle_ema_threshold
      , max_allowed_global_constants_depth
      , max_anon_ops_per_block
      , max_micheline_bytes_limit
      , max_micheline_node_count
      , max_operation_data_length
      , max_operations_time_to_live
      , max_proposals_per_delegate )
    , ( max_slashing_period
      , michelson_maximum_type_size
      , min_proposal_quorum
      , minimal_block_delay
      , minimal_participation_ratio
      , minimal_stake
      , nonce_length
      , nonce_revelation_threshold
      , origination_size
      , preserved_cycles )
    , ( proof_of_work_nonce_size
      , proof_of_work_threshold
      , quorum_max
      , quorum_min
      , ratio_of_frozen_deposits_slashed_per_double_endorsement
      , sc_max_wrapped_proof_binary_size
      , sc_rollup_challenge_window_in_blocks
      , sc_rollup_commitment_period_in_blocks
      , sc_rollup_enable
      , sc_rollup_max_active_outbox_levels )
    , ( sc_rollup_max_lookahead_in_blocks
      , sc_rollup_max_number_of_cemented_commitments
      , sc_rollup_max_number_of_messages_per_commitment_period
      , sc_rollup_max_outbox_messages_per_level
      , sc_rollup_message_size_limit
      , sc_rollup_number_of_sections_in_dissection
      , sc_rollup_origination_size
      , sc_rollup_stake_amount
      , sc_rollup_timeout_period_in_blocks
      , seed_nonce_revelation_tip )
    , ( tx_rollup_commitment_bond
      , tx_rollup_cost_per_byte_ema_factor
      , tx_rollup_enable
      , tx_rollup_finality_period
      , tx_rollup_hard_size_limit_per_inbox
      , tx_rollup_hard_size_limit_per_message
      , tx_rollup_max_commitments_count
      , tx_rollup_max_inboxes_count
      , tx_rollup_max_messages_per_inbox
      , tx_rollup_max_ticket_payload_size )
    , ( tx_rollup_max_withdrawals_per_batch
      , tx_rollup_origination_size
      , tx_rollup_rejection_max_proof_size
      , tx_rollup_sunset_level
      , tx_rollup_withdraw_period
      , vdf_difficulty
      , zk_rollup_enable
      , zk_rollup_min_pending_to_process
      , zk_rollup_origination_size ) ) =
  {
    baking_reward_bonus_per_slot
  ; baking_reward_fixed_portion
  ; blocks_per_commitment
  ; blocks_per_cycle
  ; blocks_per_stake_snapshot
  ; cache_layout_size
  ; cache_sampler_state_cycles
  ; cache_script_size
  ; cache_stake_distribution_cycles
  ; consensus_committee_size
  ; consensus_threshold
  ; cost_per_byte
  ; cycles_per_voting_period
  ; dal_parametric
  ; delay_increment_per_round
  ; double_baking_punishment
  ; endorsing_reward_per_slot
  ; frozen_deposits_percentage
  ; hard_gas_limit_per_block
  ; hard_gas_limit_per_operation
  ; hard_storage_limit_per_operation
  ; liquidity_baking_subsidy
  ; liquidity_baking_toggle_ema_threshold
  ; max_allowed_global_constants_depth
  ; max_anon_ops_per_block
  ; max_micheline_bytes_limit
  ; max_micheline_node_count
  ; max_operation_data_length
  ; max_operations_time_to_live
  ; max_proposals_per_delegate
  ; max_slashing_period
  ; michelson_maximum_type_size
  ; min_proposal_quorum
  ; minimal_block_delay
  ; minimal_participation_ratio
  ; minimal_stake
  ; nonce_length
  ; nonce_revelation_threshold
  ; origination_size
  ; preserved_cycles
  ; proof_of_work_nonce_size
  ; proof_of_work_threshold
  ; quorum_max
  ; quorum_min
  ; ratio_of_frozen_deposits_slashed_per_double_endorsement
  ; sc_max_wrapped_proof_binary_size
  ; sc_rollup_challenge_window_in_blocks
  ; sc_rollup_commitment_period_in_blocks
  ; sc_rollup_enable
  ; sc_rollup_max_active_outbox_levels
  ; sc_rollup_max_lookahead_in_blocks
  ; sc_rollup_max_number_of_cemented_commitments
  ; sc_rollup_max_number_of_messages_per_commitment_period
  ; sc_rollup_max_outbox_messages_per_level
  ; sc_rollup_message_size_limit
  ; sc_rollup_number_of_sections_in_dissection
  ; sc_rollup_origination_size
  ; sc_rollup_stake_amount
  ; sc_rollup_timeout_period_in_blocks
  ; seed_nonce_revelation_tip
  ; tx_rollup_commitment_bond
  ; tx_rollup_cost_per_byte_ema_factor
  ; tx_rollup_enable
  ; tx_rollup_finality_period
  ; tx_rollup_hard_size_limit_per_inbox
  ; tx_rollup_hard_size_limit_per_message
  ; tx_rollup_max_commitments_count
  ; tx_rollup_max_inboxes_count
  ; tx_rollup_max_messages_per_inbox
  ; tx_rollup_max_ticket_payload_size
  ; tx_rollup_max_withdrawals_per_batch
  ; tx_rollup_origination_size
  ; tx_rollup_rejection_max_proof_size
  ; tx_rollup_sunset_level
  ; tx_rollup_withdraw_period
  ; vdf_difficulty
  ; zk_rollup_enable
  ; zk_rollup_min_pending_to_process
  ; zk_rollup_origination_size
  }

let obj =
  let open Data_encoding in
  tup8
    (obj10
       (req "baking_reward_bonus_per_slot" z)
       (req "baking_reward_fixed_portion" z)
       (req "blocks_per_commitment" int31)
       (req "blocks_per_cycle" int31)
       (req "blocks_per_stake_snapshot" int31)
       (req "cache_layout_size" int31)
       (req "cache_sampler_state_cycles" int31)
       (req "cache_script_size" int31)
       (req "cache_stake_distribution_cycles" int31)
       (req "consensus_committee_size" int31))
    (obj10
       (req "consensus_threshold" int31)
       (req "cost_per_byte" z)
       (req "cycles_per_voting_period" int31)
       (req "dal_parametric" dal_parametric_encoding)
       (req "delay_increment_per_round" z)
       (req "double_baking_punishment" z)
       (req "endorsing_reward_per_slot" z)
       (req "frozen_deposits_percentage" int31)
       (req "hard_gas_limit_per_block" z)
       (req "hard_gas_limit_per_operation" z))
    (obj10
       (req "hard_storage_limit_per_operation" z)
       (req "liquidity_baking_subsidy" z)
       (req "liquidity_baking_toggle_ema_threshold" int64)
       (req "max_allowed_global_constants_depth" int31)
       (req "max_anon_ops_per_block" int31)
       (req "max_micheline_bytes_limit" int31)
       (req "max_micheline_node_count" int31)
       (req "max_operation_data_length" int31)
       (req "max_operations_time_to_live" int31)
       (req "max_proposals_per_delegate" int31))
    (obj10
       (req "max_slashing_period" int31)
       (req "michelson_maximum_type_size" int31)
       (req "min_proposal_quorum" int31)
       (req "minimal_block_delay" z)
       (req "minimal_participation_ratio" fraction_encoding)
       (req "minimal_stake" z) (req "nonce_length" int31)
       (req "nonce_revelation_threshold" int31)
       (req "origination_size" int31)
       (req "preserved_cycles" int31))
    (obj10
       (req "proof_of_work_nonce_size" int31)
       (req "proof_of_work_threshold" z)
       (req "quorum_max" int31) (req "quorum_min" int31)
       (req "ratio_of_frozen_deposits_slashed_per_double_endorsement"
          fraction_encoding)
       (req "sc_max_wrapped_proof_binary_size" int31)
       (req "sc_rollup_challenge_window_in_blocks" int31)
       (req "sc_rollup_commitment_period_in_blocks" int31)
       (req "sc_rollup_enable" bool)
       (req "sc_rollup_max_active_outbox_levels" int31))
    (obj10
       (req "sc_rollup_max_lookahead_in_blocks" int31)
       (req "sc_rollup_max_number_of_cemented_commitments" int31)
       (req "sc_rollup_max_number_of_messages_per_commitment_period" int64)
       (req "sc_rollup_max_outbox_messages_per_level" int31)
       (req "sc_rollup_message_size_limit" int31)
       (req "sc_rollup_number_of_sections_in_dissection" int31)
       (req "sc_rollup_origination_size" int31)
       (req "sc_rollup_stake_amount" z)
       (req "sc_rollup_timeout_period_in_blocks" int31)
       (req "seed_nonce_revelation_tip" z))
    (obj10
       (req "tx_rollup_commitment_bond" z)
       (req "tx_rollup_cost_per_byte_ema_factor" int31)
       (req "tx_rollup_enable" bool)
       (req "tx_rollup_finality_period" int31)
       (req "tx_rollup_hard_size_limit_per_inbox" int31)
       (req "tx_rollup_hard_size_limit_per_message" int31)
       (req "tx_rollup_max_commitments_count" int31)
       (req "tx_rollup_max_inboxes_count" int31)
       (req "tx_rollup_max_messages_per_inbox" int31)
       (req "tx_rollup_max_ticket_payload_size" int31))
    (obj9
       (req "tx_rollup_max_withdrawals_per_batch" int31)
       (req "tx_rollup_origination_size" int31)
       (req "tx_rollup_rejection_max_proof_size" int31)
       (req "tx_rollup_sunset_level" int31)
       (req "tx_rollup_withdraw_period" int31)
       (req "vdf_difficulty" z)
       (req "zk_rollup_enable" bool)
       (req "zk_rollup_min_pending_to_process" int31)
       (req "zk_rollup_origination_size" int31))

let encoding = Data_encoding.conv inj proj obj
