#!/usr/bin/env ruby
require_relative('../lib/catapult.rb')
require 'byebug'
require 'yaml'
test_keys_path = File.expand_path('../../test/component_keys.yaml', File.dirname(__FILE__))

keys = YAML.load(File.open(test_keys_path).read)
Catapult::Config::CatapultNode::PeerNode.configure(keys: keys)

