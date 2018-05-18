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
  class Config
    class NemesisPropertiesFile
      require_relative('nemesis_properties_file/template_bindings')

      CONFIG_FILENAME = 'block-properties-file.properties'

      def initialize(keys, nemesis_dir)
        @input_attributes =  { keys: keys }
        @nemesis_dir      = nemesis_dir
      end

      private :initialize

      def self.generate_and_write_nemesis_properties_file(keys, nemesis_dir)
        new(keys, nemesis_dir).generate_file
      end
      def generate_file
        config_file = ret_nemesis_config
        write_config_file(config_file)
      end      

      def self.config_filename
        CONFIG_FILENAME
      end

      protected

      attr_reader :input_attributes, :nemesis_dir

      def template
        @template ||= File.open(self.template_file).read
      end

      def template_file
        "#{Config.base_config_source_dir}/nemesis/#{self.config_filename}.mt"
      end

      def config_filename
        self.class.config_filename
      end
      
      private

      def ret_nemesis_config
        nemesis_keys_info = Keys::Nemesis.get_nemesis_keys_info(self.input_attributes)
        template_bindings = TemplateBindings.template_bindings(nemesis_keys_info)
        Catapult.bind_mustache_variables(self.template, template_bindings)
      end

      def write_config_file(config_file)
        nemesis_file_path = "#{self.nemesis_dir}/#{config_filename}"
        File.open(nemesis_file_path, 'w') { |f| f << config_file }
      end
      
    end
  end
end



