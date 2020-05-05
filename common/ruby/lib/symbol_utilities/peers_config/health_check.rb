module SymbolUtilities
  class PeersConfig
    class HealthCheck < self
      include MustacheMixin
      include Aux::Mixin::NetHttp
      def initialize(target_config_dir, config_input, peer_host: nil)
        super(target_config_dir)
        @config_input = config_input
        @peer_host    ||= ret_default_peer_host
      end

      protected

      attr_reader :config_input, :peer_host
      
      def peers_config_type
        :health_check
      end

      def template_vars
        {
          public_key: self.config_input.public_key,
          host: self.peer_host
        }
      end

      private
      
      # This assumes that runing on aws and gets the nodes private ip
      def ret_default_peer_host
        net_http_get('http://169.254.169.254/latest/meta-data/local-ipv4')
      end
    end
  end
end
