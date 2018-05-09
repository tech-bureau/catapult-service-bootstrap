module Catapult
  class Config
    class CatapultNode < self
      require_relative('catapult_node/api_node')
      require_relative('catapult_node/json_peers')
      require_relative('catapult_node/peer')
      require_relative('catapult_node/peer_node')
      require_relative('catapult_node/template_attributes')
      
      DATA_SUBDIR      = 'data'
      CONFIG_SUBDIR    = 'userconfig'
      RESOURCES_SUBDIR = 'resources'

      def initialize(dtk_all_attributes)
        type            = self.class.type
        all_peers       = Peer.all_peers(dtk_all_attributes)

        @component_keys = Keys::Component.new(dtk_all_attributes)
        @json_peers     = JsonPeers.new(@component_keys, all_peers)
        super(type, dtk_all_attributes, TemplateAttributes.new(type, @component_keys, dtk_all_attributes))
      end
      private :initialize

      attr_reader :component_keys
      
      def self.configure(dtk_all_attributes)
        new(dtk_all_attributes).configure
      end
      
      def self.scripts_dir?
        check_dir_exists("#{Config.base_catapult_component_config_dir}/#{self.type}")
      end
      
      def self.json_peers_dir
        "#{self.base_catapult_component_config_dir}/common_fragments/json_peers"
      end
      
      PEER_FILE_INFO = {
        peer_node: 'peers-p2p.json',
        api_node: 'peers-api.json'
      }
      
      def self.catapult_peers_relative_paths
        PEER_FILE_INFO.map { |_peer_type, peer_filename| relative_path(:config_file, peer_filename) }
      end
      
      protected
      
      attr_reader :json_peers
      
      private
      
      def self.config_info_dir
        check_dir_exists("#{Config.base_catapult_component_config_dir}/#{self.type}/#{RESOURCES_SUBDIR}")
      end
      
      def add_instantiate_config_templates
        super
        add_instantiate_peer_json_files
      end
      
      def add_instantiate_peer_json_files
        PEER_FILE_INFO.each_pair do |peer_type, peer_filename|
          content = self.json_peers.file_content(peer_type)
          path    = relative_path(:config_file, peer_filename)
          self.component_indexes.each do |index| 
            add_config_file!(index, path, content)
          end
        end
      end

      # file_type can be :script, :config_file
      def self.relative_path?(file_type, filename)      
        case file_type
        when :config_file
          "#{CONFIG_SUBDIR}/#{RESOURCES_SUBDIR}/#{filename}"
        when :script
          "#{CONFIG_SUBDIR}/#{filename}"
        end
      end
      
    end
  end
end
