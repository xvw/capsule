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

type fraction = { denominator : int; numerator : int }

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

val encoding : t Data_encoding.t
