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
  class Config::CatapultNode
    class CertGenerate
      require_relative('cert_generate/template')
      require_relative('cert_generate/crypto')
      
      def initialize(parent)
        @parent = parent
      end

      def indexed_keys
        self.crypto_info.indexed_keys
      end
      
      def write_to_files
        self.crypto_info.write_to_files
      end
      
      CERT_SUBDIR = 'cert'
      
      InstantiatedFileInfo = Struct.new(:index, :relative_path, :content)
      # returns array of InstantiatedFileInfo 
      def instantiated_files
        # indexed_cert_cnf_files is doubly indexed, first by componnet instance and then by template index
        indexed_cert_cnf_files.values.map { |hash| hash.values }.flatten
      end

      # Indexed by component instance
      def indexed_cert_cnf_files
        @indexed_cert_cnf_files ||= self.component_indexes.inject({}) do |h, component_index|
          h.merge(component_index => Template.new(self.type, component_index, self.indexed_templates).indexed_instantiated_files)
        end
      end

      def component_cert_dir_full_path(component_index)
        "#{self.parent.component_dir_full_path(component_index)}/#{Config::CatapultNode.config_file_relative_path}/#{CERT_SUBDIR}"
      end
      
      protected

      attr_reader :parent

      def type
        @type ||= self.parent.class.type
      end

      def component_indexes
        @component_indexes ||= self.parent.component_indexes
      end
      
      def crypto_info
        @crypto_info ||= Crypto.new(self)
      end
      
      ConfigFile  = Struct.new(:template, :target_file_name)
      def indexed_templates
        @indexed_templates ||= TEMPLATE_FILE_NAMES.keys.inject({}) do |h, template_type|
          h.merge(template_type => ConfigFile.new(read_template(template_type), target_file_name(template_type)))
        end
      end
      
      def base_cert_generate_dir 
        @base_cert_generate_dir ||= "#{Catapult::Bootstrap.base_config_source_dir}/common_fragments/cert"
      end
      
      private
      
      TEMPLATE_FILE_NAMES = {
        ca_cnf: 'ca.cnf.mt',
        node_cnf: 'node.cnf.mt'
      }
      def read_template(template_type)
        ::File.read("#{self.base_cert_generate_dir}/#{template_file_name(template_type)}")
      end
      
      def target_file_name(template_type)
        template_file_name(template_type).sub(/\.mt$/, '')
      end

      def template_file_name(template_type)
        TEMPLATE_FILE_NAMES[template_type] || fail("illegal template_type '#{template_type}'")
      end

    end
  end
end
