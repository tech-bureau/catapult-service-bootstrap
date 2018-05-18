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
    class RestGateway < self
      require_relative('rest_gateway/template_attributes')

      CONFIG_SUBDIR = 'userconfig'
      TYPE          = :rest_gateway
      def initialize(input_attributes)
        @component_keys = Keys::Component.new(input_attributes)
        super(TYPE, input_attributes, TemplateAttributes.new(@component_keys, input_attributes))
      end
      private :initialize

      protected

      attr_reader :component_keys
      
      private
      
      def self.config_info_dir
        check_dir_exists("#{Config.base_config_source_dir}/#{self.type}")
      end
      
      # file_type can be :script, :config_file
      def self.relative_path?(file_type, filename)      
        case file_type
        when :config_file
          "#{CONFIG_SUBDIR}/#{filename}"
        end
      end

    end
  end
end
