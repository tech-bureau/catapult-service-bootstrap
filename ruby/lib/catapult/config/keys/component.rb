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
