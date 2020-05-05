require 'fileutils'
module SymbolUtilities
  # TODO: see if we still need the following 
  BASE_DIR      = ::File.expand_path('../../', ::File.dirname(__FILE__))
  RUBY_BASE_DIR = ::File.expand_path('../', ::File.dirname(__FILE__))
 
  require_relative('symbol_utilities/global')
  # global must go first
  require_relative('symbol_utilities/aux')
  require_relative('symbol_utilities/cert_generate')
  require_relative('symbol_utilities/config_input')
  require_relative('symbol_utilities/directory')
  require_relative('symbol_utilities/generate_certs_and_keys')
  require_relative('symbol_utilities/influxdb')
  require_relative('symbol_utilities/keys')
  require_relative('symbol_utilities/parse')
  require_relative('symbol_utilities/peers_config')
  require_relative('symbol_utilities/run_time_vars')
  require_relative('symbol_utilities/tools')
end
