[nemesis]
networkIdentifier = {{network_identifier}} 
nemesisGenerationHash = {{nemesis_generation_hash}}
nemesisSignerPrivateKey = {{nemesis_signer_private_key}}
[output]
cppFile = 
binDirectory = ../seed/mijin-test
[namespaces]
nem = true
eur = false
[namespace>nem]
duration = 0
[namespace>eur]
duration = 123456789
[mosaics]
nem:xem = true
eur:euro = false
[mosaic>nem:xem]
divisibility = 6
duration = 0
supply = {{xem.supply}}
isTransferable = true
isSupplyMutable = false
isLevyMutable = false
[distribution>nem:xem]
{{#xem.distribution}}
{{addreess}} = {{amount}}
{{/xem.distribution}}
