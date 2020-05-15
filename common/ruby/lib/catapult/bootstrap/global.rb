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
module Catapult::Bootstrap
  module Global
    module ComponentCardinaity
      HASH = { 
        api_node: 1,
        peer_node: 2,
        rest_gateway: 1
      }
      class << self
        HASH.each_pair { |k, v| define_method(k, lambda { v }) }
      end
    end

    module CertInfo
      HASH = {
        ca_cnf: 'ca.cnf',
        private_key: 'ca.key.pem',
        public_key: 'ca.pubkey.pem',
        certificate: 'ca.cert.pem',

        node_cnf: 'node.cnf',
        node_private_key: 'node.key.pem',
        node_public_key: 'node.pubkey.pem',
        node_csr_pem: 'node.csr.pem', 
        node_crt_pem: 'node.crt.pem',
        node_full_crt_pem: 'node.full.crt.pem',

        new_certs_dir: './new_certs',
        serial_file: 'serial.dat',
        database_file: 'index.txt'
      }
      class << self
        HASH.each_pair { |k, v| define_method(k, lambda { v }) }
      end
    end

    CATAPULT_NETWORK_IDENTIFIER = 'public-test'
    MONGO_HOST                  = 'db'

    def self.catapult_nework_identifier
      CATAPULT_NETWORK_IDENTIFIER 
    end

    NUM_GENERATED_ADDRESSES = 53
    def self.num_generated_addresses
      NUM_GENERATED_ADDRESSES
    end

    module ParseKey
      ARRAY = [
        :nemesis_addresses,
        :nemesis_addresses_harvesting,
        :nemesis_addresses_harvesting_vrf,
        :nemesis_generation_hash,
        :nemesis_signer_private_key,
        # TODO: below wil be removed
        :peer_nodes,
        :api_nodes,
        :rest_gateways
      ]
      class << self
        ARRAY.each { |el| define_method(el, lambda { el }) }
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
