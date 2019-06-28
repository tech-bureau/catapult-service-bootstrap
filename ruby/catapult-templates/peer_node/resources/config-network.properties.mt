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
importanceActivityPercentage = 5
maxRollbackBlocks = 40
maxDifficultyBlocks = 60

maxTransactionLifetime = 24h
maxBlockFutureTime = 10s

initialCurrencyAtomicUnits = 8'998'999'998'000'000
maxMosaicAtomicUnits = 9'000'000'000'000'000

totalChainImportance = {{{total_chain_importance}}}
minHarvesterBalance = 500
harvestBeneficiaryPercentage = 10

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

maxBondedTransactionLifetime = 48h

[plugin:catapult.plugins.lockhash]

lockedFundsPerAggregate = 10'000'000
maxHashLockDuration = 2d

[plugin:catapult.plugins.locksecret]

maxSecretLockDuration = 30d
minProofSize = 1
maxProofSize = 1000

[plugin:catapult.plugins.mosaic]

maxMosaicsPerAccount = 10'000
maxMosaicDuration = 3650d
maxMosaicDivisibility = 6

mosaicRentalFeeSinkPublicKey = {{mosaic_rental_fee_sink_public_key}}
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

namespaceRentalFeeSinkPublicKey = {{namespace_rental_fee_sink_public_key}}
rootNamespaceRentalFeePerBlock = 1'000'000
childNamespaceRentalFee = 100'000'000

maxChildNamespaces = 500

[plugin:catapult.plugins.restrictionaccount]

maxAccountRestrictionValues = 512


[plugin:catapult.plugins.transfer]

maxMessageSize = 1024

