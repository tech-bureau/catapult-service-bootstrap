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
  class Config::CatapultNode
    class JsonPeers
      def initialize(component_keys, all_peers)
        @component_keys = component_keys
        @all_peers      = all_peers
      end
      
      # peer_type will be :peer_node or :api_node
      def file_content(peer_type)
        known_peers(peer_type)
      end
      
      protected
      
      attr_reader :component_keys, :all_peers
      
      def known_peer_template
        @known_peer_template ||= template_content('known_peer.mt')
      end
      
      # indexed by [peer_type][index]
      def ndx_public_keys
        @ndx_public_keys ||= ret_ndx_public_keys
      end
      
      private
      
      def known_peers(peer_type)
        ret = ''
        ret << "{\n"
        ret << "  \"_info\": \"this file contains a list of #{peer_type} peers\",\n"
        ret << "  \"knownPeers\": [\n"
        ret << known_peers_body(peer_type)
        ret << "  ]\n"
        ret << "}\n"
        ret
      end
      
      def known_peers_body(peer_type)
        ret = ''
        peer_info_array = peer_info_array(peer_type)
          last_index      = peer_info_array.size - 1
          peer_info_array.each_with_index do |peer_info_hash, index|
            ret << instantiate_known_peer(peer_info_hash).chomp
            ret << ',' unless index == last_index
            ret << "\n"
          end
          ret
      end
      
      def instantiate_known_peer(peer_info_hash)
        Catapult.bind_mustache_variables(self.known_peer_template, peer_info_hash)
      end
      
      def peer_info_array(peer_type)
        self.all_peers.map do |peer|
          if peer.type == peer_type
            {
              peer_publickey: peer_publickey(peer),
              peer_host: peer.host_address,
              peer_port: peer.port,
              peer_name: peer.name,
              peer_role: peer.type == :peer_node ? 'Peer' : 'Api'
            }
          end
        end.compact
      end
      
      def peer_publickey(peer)
        (self.ndx_public_keys[peer.type] || {})[peer.index] || 
          fail("Unexpected that there is no public key for '#{peer.type}-#{peer.index}'")
      end
      
      def ret_ndx_public_keys
        [:api_node, :peer_node].inject({}) do |h, component_type|
          h.merge(component_type => self.component_keys.get_keys_info_array(component_type).map(&:public))
        end
      end
      
      def template_content(filename)
        File.open("#{Config::CatapultNode.json_peers_dir}/#{filename}").read
      end
      
    end
  end
end
