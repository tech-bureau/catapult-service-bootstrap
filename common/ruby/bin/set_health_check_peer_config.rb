#!/usr/bin/env ruby

require_relative('../lib/symbol_utilities')

CONFIG_INPUT_DIR  = '/config-data'
TARGET_CONFIG_DIR = '/userconfig/resources'

config_input = SymbolUtilities::ConfigInput.new(CONFIG_INPUT_DIR)
SymbolUtilities::PeersConfig::HealthCheck.new(TARGET_CONFIG_DIR, config_input).install
