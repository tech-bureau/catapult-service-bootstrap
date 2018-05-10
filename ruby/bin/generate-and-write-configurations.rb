#!/usr/bin/env ruby
require 'byebug'
require_relative('../lib/catapult.rb')
keys_file_path         = ARGV[0]
base_config_target_dir = ARGV[1]
nemesis_dir            = ARGV[2]

keys = YAML.load(File.open(keys_file_path).read)
Catapult::Config.generate_and_write_configurations(keys, base_config_target_dir, nemesis_dir)

