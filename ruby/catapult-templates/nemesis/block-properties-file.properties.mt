[nemesis]

networkIdentifier = {{network_identifier}}
nemesisGenerationHashSeed = {{nemesis_generation_hash}}
nemesisSignerPrivateKey = {{nemesis_signer_private_key}}

[cpp]

cppFileHeader =

[output]

cppFile =
binDirectory = {{bin_directory}}

[transactions]
transactionsDirectory = {{transactions_directory}}

[namespaces]

{{base_namespace}} = true
{{base_namespace}}.{{mosaic_name.currency}} = true
{{base_namespace}}.{{mosaic_name.harvesting}} = true

[namespace>{{base_namespace}}]

duration = 0

[mosaics]

{{base_namespace}}:{{mosaic_name.currency}} = true
{{base_namespace}}:{{mosaic_name.harvesting}} = true

[mosaic>{{base_namespace}}:{{mosaic_name.currency}}]

divisibility = 6
duration = 0
supply = 8'998'999'998'000'000
isTransferable = true
isSupplyMutable = false
isRestrictable = false

[distribution>{{base_namespace}}:{{mosaic_name.currency}}]
{{#currency_distribution}}
{{address}} = {{amount}}
{{/currency_distribution}}

[mosaic>{{base_namespace}}:{{mosaic_name.harvesting}}]

divisibility = 3
duration = 0
supply = 15'000'000
isTransferable = true
isSupplyMutable = true
isRestrictable = false

[distribution>{{base_namespace}}:{{mosaic_name.harvesting}}]
{{#harvesting_distribution}}
{{address}} = {{amount}}
{{/harvesting_distribution}}

