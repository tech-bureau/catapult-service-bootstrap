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
  class Config::RestGateway
    class TemplateAttributes
      def initialize(component_keys, input_attributes)
        @component_keys   = component_keys
        @input_attributes = input_attributes
      end
      
      attr_reader :component_keys
      
      def hash(index)
        {
          rest_gateway_private_key: rest_gateway_private_key(index),
          api_node_host: api_node_host(index),
          api_node_public_key: api_node_public_key(index)
        }
      end
      
      private
      
      def rest_gateway_private_key(index)
        self.component_keys.get_key(:private, :rest_gateway, index)
      end
      
      # Mapping all rest gateways to api node 0
      API_NODE_INDEX = 0
      
      def api_node_host(_index)
        Global.component_address(:api_node, API_NODE_INDEX)
      end
      
      def api_node_public_key(_index)
        self.component_keys.get_key(:public, :api_node, API_NODE_INDEX)
      end
    end
  end        
end
