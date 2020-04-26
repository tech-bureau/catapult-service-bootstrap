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
    class TemplateAttributes
      require_relative('template_attributes/per_index')
      def initialize(type, component_keys, keys_handle)
        @type           = type
        @component_keys = component_keys
        @keys_handle    = keys_handle
      end
        
      attr_reader :type, :component_keys
      
      def hash(index)
        PerIndex.new(self, index).hash
      end
      
      def harvest_keys
        @harvest_keys ||= Config::Keys::Nemesis.get_keys_info_array_for_harvesting(self.keys_handle).map(&:private)
      end

      def network_public_key
        @network_public_key ||= Config::Keys::Nemesis.key_info_signer_private_key(self.keys_handle).public
      end

      def network_generation_hash
        @network_generation_hash ||= Config::Keys::Nemesis.key_info_generation_hash(self.keys_handle).public
      end

      protected

      attr_reader :keys_handle

    end        
  end
end



 

