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
  class Config::Nemesis
    class BlockPropertiesFile < self
      require_relative('block_properties_file/template_bindings')

      CONFIG_FILENAME = 'block-properties-file.properties'
      
      def generate_and_write
        write_config_file(self.config_content)
      end
      
      def self.full_path 
        "#{Directory::Nemesis.full_path}/#{CONFIG_FILENAME}"
      end

      BIN_DIRECTORY = 'seed'
      def self.bin_directory
        BIN_DIRECTORY
      end

      BASE_NAMESPACE = 'cat'
      def self.base_namespace
        BASE_NAMESPACE
      end

      CURRENCY_MOSAIC_NAME   = 'currency'
      HARVESTING_MOSAIC_NAME = 'harvest'
      MosaicNameStruct = Struct.new(:currency, :harvesting)
      def self.mosaic_name
        MosaicNameStruct.new(CURRENCY_MOSAIC_NAME, HARVESTING_MOSAIC_NAME)
      end

      protected
      
      def config_content
        @config_content ||= bind_mustache_variables(self.template, self.template_bindings)
      end

      def template_bindings
        TemplateBindings.template_bindings(self.nemesis_keys_info, self.harvest_vrf_directory)
      end

      def template
        @template ||= File.open(self.template_file).read
      end
      
      def template_file
        "#{Config.base_config_source_dir}/nemesis/#{CONFIG_FILENAME}.mt"
      end
      
      private
      
      def write_config_file(config_file)
        File.open(self.class.full_path, 'w') { |f| f << config_file }
      end

    end
  end
end
