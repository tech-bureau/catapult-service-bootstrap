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
module SymbolUtilities
  class Keys
    class Component < self
      # indexed_cert_keys is indexed by component_index
      def initialize(keys_handle)
        super(keys_handle)
      end
      
      def self.get_key(key_type, component_type, component_index, keys_handle)
        new(keys_handle).get_key(key_type, component_type, component_index)
      end
      def get_key(key_type, component_type, component_index)
        get_key_info_from_certs(component_type.to_sym, component_index, key_type.to_sym) 
      end
      
      # doubly indexed; first by component type and then by component index
      def indexed_public_keys
        indexed_cert_keys.inject({}) do |h, (component_type, indexed_by_num)|
          indexed_info = indexed_by_num.inject({}) do |h, (component_index, key_info)|
            h.merge(component_index => key_info.public_key)
          end
          h.merge(component_type => indexed_info)
        end
      end
      
      protected
      
      # indexed_cert_keys is doubly indexed; first by component type and then by component index
      def indexed_cert_keys
        self.keys_handle.indexed_cert_keys
      end

      private
      
      def get_key_info_from_certs(component_type, component_index, key_type)
        if key_info = (self.indexed_cert_keys[component_type] || {})[component_index]
          key_info.send("#{key_type}_key".to_sym)
        else
          fail("get_key_info_from_certs(#{component_type}, #{component_index}, #{key_type})")
        end
      end
      
    end
  end
end
