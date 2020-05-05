#!/usr/bin/env ruby
require_relative('../lib/symbol_utilities')

unless ARGV.size == 1
  STDERR << "Usage #{$0} NODE_TYPE\n"
  exit 1
end

node_type = ARGV[0]

BASE_DIR = '/usr/app'
target_config_dir = "#{BASE_DIR}/#{node_type}/userconfig/resources"
identity_dir      = "#{BASE_DIR}/identity"

unless ::Dir.exists?(target_config_dir)
  STDERR << "Target directory '#{target_config_dir}' does not exist"
end
unless ::Dir.exists?(identity_dir)
  STDERR << "Identity directory '#{identity_dir}' does not exist"
end
SymbolUtilities::Directory.set_base!(BASE_DIR)
SymbolUtilities::Directory.set_identity!(identity_dir)

SymbolUtilities::GenerateCertsAndKeys.generate(node_type)
SymbolUtilities::RunTimeVars::SetVar.run
SymbolUtilities::PeersConfig::RemoteStore.new(target_config_dir).install

