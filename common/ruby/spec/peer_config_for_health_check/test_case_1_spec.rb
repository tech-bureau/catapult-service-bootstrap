require_relative('../../lib/symbol_utilities')
require 'byebug' 
require 'fileutils'
require 'json'
describe SymbolUtilities::PeersConfig::HealthCheck do
  before(:all) do
    config_input_dir  = '/config-data'
    @target_conf_dir = "/tmp/peer_config_for_health_check#{rand(1..100000000)}"
    ::FileUtils.mkdir_p @target_conf_dir
    config_input = SymbolUtilities::ConfigInput.new(config_input_dir)
    SymbolUtilities::PeersConfig::HealthCheck.new(@target_conf_dir, config_input).install
  end
  subject(:peers_p2p_json) { ::File.read("#{@target_conf_dir}/peers-p2p.json") }
  
  it { STDOUT << peers_p2p_json }

  let(:peers_p2p) { ::JSON.parse(peers_p2p_json) }
  subject(:known_peers) { peers_p2p['knownPeers'] }
  it { expect(known_peers).to be_a(::Array) }
  it { expect(known_peers.size).to eq(1) }
  it { expect(known_peers.first.keys).to eq(['publicKey', 'endpoint', 'metadata']) }

  after(:all) do
    ::FileUtils.rm_rf @target_conf_dir
  end
end
