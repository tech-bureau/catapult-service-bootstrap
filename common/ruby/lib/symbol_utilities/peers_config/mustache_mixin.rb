module SymbolUtilities
  class PeersConfig
    module MustacheMixin
      include Aux::Mixin::Mustache
      def install
        peers_config = mustache_render(self.mustache_template, self.template_vars)
        write_peer_config(peers_config)
      end
      
      protected
      
      def mustache_template
        @mustache_template ||= ::File.open(self.mustache_template_path).read 
      end
      
      def mustache_template_path
        ::File.expand_path("#{self.peers_config_type}/#{PeersConfig::PEER_FILENAME}.mt", ::File.dirname(__FILE__))
      end
      
    end
  end
end
