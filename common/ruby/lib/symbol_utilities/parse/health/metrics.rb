module SymbolUtilities
  module Parse
    # TODO: should associate metrics with Symbol versions
    class Health
      METRICS = %w(
        ACCTREST_C  
        ACNTST_C
        ACNTST_C_HVA
        ACTIVE_PINGS
        BAN_ACT
        BAN_ALL
        BLK_ELEM_ACT
        BLK_ELEM_TOT
        BLKDIF_C
        HASH_C
        HASHLOCK_C
        MEM_CUR_RSS
        MEM_CUR_VIRT
        MEM_MAX_RSS
        MEM_SHR_RSS
        METADATA_C
        MOSAIC_C
        MOSAICREST_C
        MULTISIG_C
        NODES
        NS_C
        NS_C_AS
        NS_C_DS
        RB_COMMIT_ALL
        RB_COMMIT_RCT
        RB_IGNORE_ALL
        RB_IGNORE_RCT
        READERS
        SECRETLOCK_C
        SUCCESS_PINGS
        TASKS
        TOT_CONF_TXES
        TOTAL_PINGS
        TS_NODE_AGE
        TS_OFFSET_ABS
        TS_OFFSET_DIR
        TS_TOTAL_REQ
        TX_ELEM_ACT
        TX_ELEM_TOT
        UNLKED_ACCTS
        UT_CACHE
        WRITERS)
    end
  end
end

