module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen
    class ProcessNode < self
      def initialize(node_ref, parent)
        @node_ref = node_ref
        @parent   = parent
      end
      private :initialize

      def self.process?(node_ref, parent)
        new(node_ref, parent).process?
      end
      def process?
        if needs_processing?
          update_config_network_file
          copy_data_to_node
        end
      end

      protected

      attr_reader :node_ref, :parent

      def node_dir
        @node_dir ||= Config.component_data_dir(self.node_ref_hash)
      end

      def temp_data_dir
        @temp_data_dir ||= self.parent.temp_data_dir
      end

      def mosaics
        self.parent.mosaics
      end

      def component_userconfig_dir
        @component_userconfig_dir ||= Config.component_userconfig_dir(self.node_ref_hash)
      end

      def node_ref_hash
        @node_ref_hash ||= { type: self.node_ref.type, index: self.node_ref.index }
      end

      private

      # Test is looking for presence of file  00001.dat in 00000 directory
      TEST_FILE_RELATIVE_PATH = '00000/00001.dat'
      def needs_processing?
        ! ::File.file?("#{self.node_dir}/#{TEST_FILE_RELATIVE_PATH}")
      end

      def copy_data_to_node
        ::FileUtils.rm_rf(self.node_dir)
        ::FileUtils.cp_r(self.temp_data_dir, self.node_dir)
      end

      def update_config_network_file
        self.mosaics.update_config_network_file(self.component_userconfig_dir)
      end

    end
  end
end
