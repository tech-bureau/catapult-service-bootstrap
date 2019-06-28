[extensions]

# api extensions
extension.filespooling = true
extension.partialtransaction = true

# addressextraction must be first because mongo and zeromq depend on extracted addresses
extension.addressextraction = false
extension.mongo = false
extension.zeromq = false

# p2p extensions
extension.eventsource = false
extension.harvesting = false
extension.syncsource = false

# common extensions
extension.diagnostics = true
extension.hashcache = true
extension.networkheight = true
extension.nodediscovery = true
extension.packetserver = true
extension.pluginhandlers = true
extension.sync = true
extension.timesync = true
extension.transactionsink = true
extension.unbondedpruning = true
