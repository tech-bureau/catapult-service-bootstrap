module Catapult
  module Global
    CATAPULT_NETWORK_IDENTIFIER = 'mijin-test'
    MONGO_HOST                  = 'db'

    def self.catapult_nework_identifier
      CATAPULT_NETWORK_IDENTIFIER 
    end

    module ParseKey
      def self.peer_nodes
        :peer_nodes
      end
      def self.api_nodes
        :api_nodes
      end
      def self.rest_gateways
        :rest_gateways
      end
      def self.nemesis_addresses
        :nemesis_addresses
      end
      def self.nemesis_addresses_harvesting
        :nemesis_addresses_harvesting
      end
      def self.nemesis_generation_hash
         :nemesis_generation_hash
      end
      def self.nemesis_signer_private_key
        :nemesis_signer_private_key
      end
    end      

    def self.component_address(node_type, index)
      "#{node_type.to_s.gsub('_','-')}-#{index}"
    end

    def self.mongo_host
      MONGO_HOST
    end

    module CatapultPort
      PEER_PORT = 7900
      API_PORT  = 7902
      
      # node_type value in set {:peer_node, :api_node}
      def self.peer_port(node_type)
        PEER_PORT 
      end
      
      def self.api_port
        API_PORT 
      end
    end
    
  end
end
