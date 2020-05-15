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
  class Config
    class CatapultNode < self
      require_relative('catapult_node/api_node')
      require_relative('catapult_node/cert_generate')
      require_relative('catapult_node/json_peers')
      require_relative('catapult_node/peer')
      require_relative('catapult_node/peer_node')
      require_relative('catapult_node/template_attributes')
      
      CONFIG_SUBDIR    = 'userconfig'
      RESOURCES_SUBDIR = 'resources'

      def initialize(keys_handle = nil)
        @keys_handle = keys_handle
        super(self.class.type, TemplateAttributes.new(self.class.type, self.component_keys, keys_handle))
      end
      private :initialize

      attr_writer :keys_handle

      def component_keys
        @component_keys ||= Keys::Component.new(keys_handle)
      end
      
      def cert_keys_indexed_by_component_index
        self.cert_generate.indexed_keys
      end

      def self.json_peers_dir
        "#{self.base_config_source_dir}/common_fragments/json_peers"
      end
      
      PEER_FILE_INFO = {
        peer_node: 'peers-p2p.json',
        api_node: 'peers-api.json'
      }
      
      def self.catapult_peers_relative_paths
        PEER_FILE_INFO.map { |_peer_type, peer_filename| relative_path(:config_file, peer_filename) }
      end
      
      def self.config_file_relative_path
        "#{CONFIG_SUBDIR}/#{RESOURCES_SUBDIR}"
      end   

      protected

      def keys_handle
        @keys_handle || fail("@keys_handle is nil")
      end

      def cert_generate
        @cert_generate ||= CertGenerate.new(self)
      end

      def json_peers
        @json_peers ||= JsonPeers.new(self.component_keys, Peer.all_peers)
      end
      
      private
      
      def self.config_info_dir
        check_dir_exists("#{Config.base_config_source_dir}/#{self.type}/#{RESOURCES_SUBDIR}")
      end
      
      def add_instantiate_config_templates!
        super
        write_crypto_info_to_files
        add_instantiate_peer_json_files!
      end

      def write_crypto_info_to_files
        self.cert_generate.write_to_files
      end

      def add_instantiate_peer_json_files!
        PEER_FILE_INFO.each_pair do |peer_type, peer_filename|
          content       = self.json_peers.file_content(peer_type)
          relative_path = relative_path(:config_file, peer_filename)
          self.component_indexes.each do |index| 
            add_config_file!(index, relative_path, content)
          end
        end
      end

      # file_type can be :script, :config_file
      def self.relative_path?(file_type, filename)      
        case file_type
        when :config_file
          "#{self.config_file_relative_path}/#{filename}"
        when :script
          "#{CONFIG_SUBDIR}/#{filename}"
        end
      end
      
    end
  end
end

