module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen::Mosaics
    class ConfigNetwork
      def initialize(component_userconfig_dir, mosaics)
        @component_userconfig_dir = component_userconfig_dir
        @mosaics                  = mosaics
      end
      
      def self.update_file(component_userconfig_dir, mosaics)
        new(component_userconfig_dir, mosaics).update_file
      end

      def update_file
        updated_content = ''
        read_config_network_content.each_line do |line|
          if new_line = replaced_line?(line)
            updated_content += "#{new_line}"
          else
            updated_content += "#{line}"
          end
        end
        write_config_network_content(updated_content)
      end

      protected

      attr_reader :mosaics, :component_userconfig_dir

      RESOURCES_DIR           = 'resources'
      CONFIG_NETWORK_FILENAME = 'config-network.properties'
      def config_network_file_path
        @config_network_file_path ||= "#{self.component_userconfig_dir}/#{RESOURCES_DIR}/#{CONFIG_NETWORK_FILENAME}"
      end

      private
      MATCHING_LINES_INFO = {
        currency_mosaic_id: 'currencyMosaicId',
        harvesting_mosaic_id: 'harvestingMosaicId'
      }
      MATCHING_LINES_REGEXP = MATCHING_LINES_INFO.inject({}) { |h, (k, v)| h.merge(k => ::Regexp.new("^#{v}")) }

      def replaced_line?(line)
        MATCHING_LINES_REGEXP.each_pair do |key, regexp|
          if line =~ regexp
            return "#{MATCHING_LINES_INFO[key]} = #{self.mosaics.send(key)}\n"
          end
        end
        nil
      end

      def read_config_network_content
        ::File.open(self.config_network_file_path)
      end

      def write_config_network_content(updated_content)
        ::File.open(self.config_network_file_path, 'w') { |f| f << updated_content }
      end

    end
  end
end
