[network]

identifier = {{network_identifier}}
nodeEqualityStrategy = public-key
publicKey = {{network_public_key}}
generationHash = {{network_generation_hash}}

[chain]

enableVerifiableState = {{enable_verifiable_state}}
enableVerifiableReceipts = {{enable_verifiable_receipts}}

currencyMosaicId = {{{currency_mosaic_id}}}
harvestingMosaicId = {{{harvesting_mosaic_id}}}

blockGenerationTargetTime = 15s
blockTimeSmoothingFactor = 3000

importanceGrouping = 39
importanceActivityPercentage = 5
maxRollbackBlocks = 40
maxDifficultyBlocks = 60
defaultDynamicFeeMultiplier = 10'000

maxTransactionLifetime = 24h
maxBlockFutureTime = 500ms

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

[plugin:catapult.plugins.metadata]

maxValueSize = 1024

[plugin:catapult.plugins.mosaic]

maxMosaicsPerAccount = 10'000
maxMosaicDuration = 3650d
maxMosaicDivisibility = 6

mosaicRentalFeeSinkPublicKey = {{mosaic_rental_fee_sink_public_key}}
mosaicRentalFee = 500

[plugin:catapult.plugins.multisig]

maxMultisigDepth = 3
maxCosignatoriesPerAccount = 10
maxCosignedAccountsPerAccount = 5

[plugin:catapult.plugins.namespace]

maxNameSize = 64
maxChildNamespaces = 500
maxNamespaceDepth = 3

# *approximate* days based on blockGenerationTargetTime
minNamespaceDuration = 1m
maxNamespaceDuration = 365d
namespaceGracePeriodDuration = 2m
reservedRootNamespaceNames = xem, nem, user, account, org, com, biz, net, edu, mil, gov, info

namespaceRentalFeeSinkPublicKey = {{namespace_rental_fee_sink_public_key}}
rootNamespaceRentalFeePerBlock = 1
childNamespaceRentalFee = 100

[plugin:catapult.plugins.restrictionaccount]

maxAccountRestrictionValues = 512

[plugin:catapult.plugins.restrictionmosaic]

maxMosaicRestrictionValues = 20

[plugin:catapult.plugins.transfer]

maxMessageSize = 1024
