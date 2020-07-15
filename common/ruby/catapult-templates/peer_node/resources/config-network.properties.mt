[network]

identifier = {{network_identifier}}
nodeEqualityStrategy = host
nemesisSignerPublicKey = {{network_public_key}}
generationHashSeed = {{network_generation_hash}}
epochAdjustment = 1573430400s

[chain]

enableVerifiableState = {{enable_verifiable_state}}
enableVerifiableReceipts = {{enable_verifiable_receipts}}

currencyMosaicId = {{{currency_mosaic_id}}}
harvestingMosaicId = {{{harvesting_mosaic_id}}}

blockGenerationTargetTime = 15s
blockTimeSmoothingFactor = 3000
blockFinalizationInterval = 30

importanceGrouping = 1433
importanceActivityPercentage = 5
maxRollbackBlocks = 1433
maxDifficultyBlocks = 60
defaultDynamicFeeMultiplier = 1'000

maxTransactionLifetime = 24h
maxBlockFutureTime = 500ms

initialCurrencyAtomicUnits = 8'998'999'998'000'000
maxMosaicAtomicUnits = 9'000'000'000'000'000

totalChainImportance = {{{total_chain_importance}}}
minHarvesterBalance = 500
maxHarvesterBalance = 50'000'000'000'000
minVoterBalance = 50'000

# assuming finalization ~20 minutes
maxVotingKeysPerAccount = 3
minVotingKeyLifetime = 72
maxVotingKeyLifetime = 26280

harvestBeneficiaryPercentage = 10
harvestNetworkPercentage = 5
harvestNetworkFeeSinkAddress = TDGY4DD2U4YQQGERFMDQYHPYS6M7LHIF6XUCJ4Q

blockPruneInterval = 360
maxTransactionsPerBlock = 6'000

[plugin:catapult.plugins.accountlink]

dummy = to trigger plugin load

[plugin:catapult.plugins.aggregate]

maxTransactionsPerAggregate = 1'000
maxCosignaturesPerAggregate = 25

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

maxMosaicsPerAccount = 1'000
maxMosaicDuration = 3650d
maxMosaicDivisibility = 6

mosaicRentalFeeSinkAddress = TDGY4DD2U4YQQGERFMDQYHPYS6M7LHIF6XUCJ4Q
mosaicRentalFee = 500

[plugin:catapult.plugins.multisig]

maxMultisigDepth = 3
maxCosignatoriesPerAccount = 25
maxCosignedAccountsPerAccount = 25

[plugin:catapult.plugins.namespace]

maxNameSize = 64
maxChildNamespaces = 256
maxNamespaceDepth = 3

# *approximate* days based on blockGenerationTargetTime
minNamespaceDuration = 1m
maxNamespaceDuration = 365d
namespaceGracePeriodDuration = 30d
reservedRootNamespaceNames = xem, nem, user, account, org, com, biz, net, edu, mil, gov, info

namespaceRentalFeeSinkAddress = TDGY4DD2U4YQQGERFMDQYHPYS6M7LHIF6XUCJ4Q
rootNamespaceRentalFeePerBlock = 1
childNamespaceRentalFee = 100

[plugin:catapult.plugins.restrictionaccount]

maxAccountRestrictionValues = 512

[plugin:catapult.plugins.restrictionmosaic]

maxMosaicRestrictionValues = 20

[plugin:catapult.plugins.transfer]

maxMessageSize = 1024
