module SymbolUtilities
  class PeersConfig
    require_relative('peers_config/mustache_mixin')
    # mustache_mixin must go first
    require_relative('peers_config/health_check')
    require_relative('peers_config/remote_store')

    PEER_FILENAME = 'peers-p2p.json'

    def initialize(target_config_dir)
      @target_config_dir = target_config_dir
    end

    protected

    attr_reader :target_config_dir

    private

    def write_peer_config(peers_config)
      ::File.open("#{self.target_config_dir}/#{PEER_FILENAME}", 'w') { |f| f << peers_config}
    end
    
  end
end
