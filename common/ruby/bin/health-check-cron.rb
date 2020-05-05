#!/usr/bin/env ruby

require_relative('../lib/symbol_utilities')
# TODO: might make this an actual bash job
FREQUENCY = 15 # in seconds

CONFIG_INPUT_DIR  = '/config-data'
DB_NAME = 'chaos_testnet'
config_input = SymbolUtilities::ConfigInput.new(CONFIG_INPUT_DIR)
influxdb_handle = SymbolUtilities::Tools::Health::InfluxdbHandle.new(DB_NAME, config_input)

while true
  begin
    SymbolUtilities::Tools::Health.get_and_write_health_info(influxdb_handle)
  rescue => e
    STDERR << e.message
    STDERR.flush
  end
  sleep FREQUENCY
end
