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
      class Template
        include Mixin::Mustache

        def initialize(type, component_index, indexed_templates)
          @type              = type
          @component_index   = component_index
          @indexed_templates = indexed_templates
        end
        
        # returns indexed elements of InstantiatedFileInfo = Struct.new(:index, :path, :content)
        # where index is template_index
        def indexed_instantiated_files
          self.indexed_templates.inject({}) do |h, (template_index, template_struct)|
            content       = instantiate_template(template_struct.template)
            relative_path = config_relative_path(template_struct.target_file_name)
            h.merge(template_index => InstantiatedFileInfo.new(self.component_index, relative_path, content))
          end
        end
        
        protected
        
        attr_reader :type, :component_index, :indexed_templates

        def config_relative_dir
          @config_relative_dir ||= "#{Config::CatapultNode.config_file_relative_path}/#{CertGenerate::CERT_SUBDIR}"
        end

        def template_attributes
          @template_attributes ||= Catapult::Bootstrap::Global::CertInfo::HASH.merge(name: self.name)
        end

        def name
          @name ||= "#{self.type.to_s.gsub('_', '-')}-#{self.component_index}"
        end

        private
        
        def instantiate_template(template)
          bind_mustache_variables(template, self.template_attributes)
        end
        
        def config_relative_path(target_file_name)
          "#{self.config_relative_dir}/#{target_file_name}"
        end

      end
    end
  end
end

