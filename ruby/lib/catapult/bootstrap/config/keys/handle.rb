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
  class Config::Keys
    class Handle
      def initialize(raw_keys_input)
        @raw_keys_input    = raw_keys_input
        # Below is dyanmically updated
        # indexed_cert_keys is double indexed; first by component type and then by component index
        @indexed_cert_keys = nil
      end

      # indexed_node_objects is indexed by component type
      def update_with_cert_info!(indexed_node_objects)    
        @indexed_cert_keys = indexed_node_objects.inject({}) do |h, (component_type, node_object)| 
          h.merge(component_type => node_object.cert_keys_indexed_by_component_index)
        end
        self
      end
      
      def parsed_content
        @parsed_content ||= ParsedContent.new(self.raw_keys_input)
      end

      def indexed_cert_keys
        @indexed_cert_keys || fail("@indexed_cert_keys is nil")
      end

      protected
      
      attr_reader :raw_keys_input
      
    end
  end
end
 
