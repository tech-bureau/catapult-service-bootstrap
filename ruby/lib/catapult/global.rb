#    Copyright 2018 Tech Bureau, Corp
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
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
