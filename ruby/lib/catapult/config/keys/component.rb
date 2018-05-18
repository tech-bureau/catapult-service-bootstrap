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
    class Keys
      class Component < self
        def self.get_key(key_type, component_type, component_index, input_attributes)
          new(input_attributes).get_key(key_type, component_type, component_index)
        end
        def get_key(key_type, component_type, component_index)
          get_key_info(component_type, component_index).send(key_type.to_sym)
        end
        
      end
    end
  end
end
