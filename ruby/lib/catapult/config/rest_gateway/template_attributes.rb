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
