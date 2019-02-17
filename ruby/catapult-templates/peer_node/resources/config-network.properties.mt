[network]

identifier = {{network_identifier}}
publicKey = {{network_public_key}}
generationHash = {{network_generation_hash}}

[chain]

shouldEnableVerifiableState = {{should_enable_verifiable_state}}
shouldEnableVerifiableReceipts = {{should_enable_verifiable_receipts}}

currencyMosaicId = {{{currency_mosaic_id}}}
harvestingMosaicId = {{{harvesting_mosaic_id}}}
blockGenerationTargetTime = 15s
blockTimeSmoothingFactor = 3000

importanceGrouping = 39
maxRollbackBlocks = 40
maxDifficultyBlocks = 60

maxTransactionLifetime = 24h
maxBlockFutureTime = 10s

totalChainImportance = {{{total_chain_importance}}}
minHarvesterBalance = 1'000

blockPruneInterval = 360
maxTransactionsPerBlock = 200'000

[plugin:catapult.plugins.accountlink]

dummy = to trigger plugin load

[plugin:catapult.plugins.aggregate]

maxTransactionsPerAggregate = 1'000
maxCosignaturesPerAggregate = 15

# multisig plugin is expected to do more advanced cosignature checks
enableStrictCosignatureCheck = false
enableBondedAggregateSupport = true

[plugin:catapult.plugins.lockhash]

lockedFundsPerAggregate = 10'000'000
maxHashLockDuration = 2d

[plugin:catapult.plugins.locksecret]

maxSecretLockDuration = 30d
minProofSize = 10
maxProofSize = 1000

[plugin:catapult.plugins.mosaic]

maxMosaicsPerAccount = 10'000

maxMosaicDuration = 3650d

isMosaicLevyUpdateAllowed = true
maxMosaicDivisibility = 6
maxMosaicDivisibleUnits = 9'000'000'000'000'000

mosaicRentalFeeSinkPublicKey = CCAEE9D1FBD5D022E42377EE3AF60455F29DDFE1FF2FA54CA1E172E9AB6D5D3F
mosaicRentalFee = 500'000'000

[plugin:catapult.plugins.multisig]

maxMultisigDepth = 3
maxCosignersPerAccount = 10
maxCosignedAccountsPerAccount = 5

[plugin:catapult.plugins.namespace]

maxNameSize = 64

# *approximate* days based on blockGenerationTargetTime
maxNamespaceDuration = 365d
namespaceGracePeriodDuration = 0d
reservedRootNamespaceNames = xem, nem, user, account, org, com, biz, net, edu, mil, gov, info

namespaceRentalFeeSinkPublicKey = CCAEE9D1FBD5D022E42377EE3AF60455F29DDFE1FF2FA54CA1E172E9AB6D5D3F
rootNamespaceRentalFeePerBlock = 1'000'000
childNamespaceRentalFee = 1'000'000

maxChildNamespaces = 500

[plugin:catapult.plugins.property]

maxPropertyValues = 512

[plugin:catapult.plugins.transfer]

maxMessageSize = 1024
