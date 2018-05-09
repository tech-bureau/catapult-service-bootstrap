#!/usr/bin/env ruby
require_relative('../lib/catapult.rb')
require 'byebug'
require 'yaml'
test_keys_path = File.expand_path('../../test/component_keys.yaml', File.dirname(__FILE__))
keys = YAML.load(File.open(test_keys_path).read)
nemesis_hash_path = File.expand_path('../../test/nemesis_generation.yaml', File.dirname(__FILE__))
nemesis_hash = YAML.load(File.open(nemesis_hash_path))
Catapult::Config.generate_nemesis_properties_file(keys: keys, nemesis_hash: nemesis_hash)

