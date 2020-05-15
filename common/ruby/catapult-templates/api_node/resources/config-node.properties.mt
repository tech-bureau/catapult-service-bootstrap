[node]

port = {{port}}
maxIncomingConnectionsPerIdentity = 6

enableAddressReuse = false
enableSingleThreadPool = false
enableCacheDatabaseStorage = {{enable_cache_database_storage}}
enableAutoSyncCleanup = false

enableTransactionSpamThrottling = true
transactionSpamThrottlingMaxBoostFee = 10'000'000

maxBlocksPerSyncAttempt = 1435
maxChainBytesPerSyncAttempt = 100MB

shortLivedCacheTransactionDuration = 10m
shortLivedCacheBlockDuration = 100m
shortLivedCachePruneInterval = 90s
shortLivedCacheMaxSize = 200'000

minFeeMultiplier = 100
transactionSelectionStrategy = maximize-fee
unconfirmedTransactionsCacheMaxResponseSize = 20MB
unconfirmedTransactionsCacheMaxSize = 50'000

connectTimeout = 15s
syncTimeout = 120s

socketWorkingBufferSize = 512KB
socketWorkingBufferSensitivity = 100
maxPacketDataSize = 150MB

blockDisruptorSize = 4096
blockElementTraceInterval = 1
transactionDisruptorSize = 16384
transactionElementTraceInterval = 10

enableDispatcherAbortWhenFull = false
enableDispatcherInputAuditing = true

maxCacheDatabaseWriteBatchSize = 5MB
maxTrackedNodes = 5'000

batchVerificationRandomSource = /dev/urandom

# all hosts are trusted when list is empty
trustedHosts = 127.0.0.1, 172.20.0.10
localNetworks = 127.0.0.1, 172.20.0.10

[localnode]

host = {{host}}
friendlyName = {{friendly_name}}
version = 0
roles = Api

[outgoing_connections]

maxConnections = 10
maxConnectionAge = 200
maxConnectionBanAge = 20
numConsecutiveFailuresBeforeBanning = 3

[incoming_connections]

maxConnections = 512
maxConnectionAge = 200
maxConnectionBanAge = 20
numConsecutiveFailuresBeforeBanning = 3
backlogSize = 512

[banning]

defaultBanDuration = 12h
maxBanDuration = 72h
keepAliveDuration = 48h
maxBannedNodes = 5'000

numReadRateMonitoringBuckets = 4
readRateMonitoringBucketDuration = 15s
maxReadRateMonitoringTotalSize = 100MB
