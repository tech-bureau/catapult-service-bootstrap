module Catapult
  class Config
    class Keys
      class Component < self
        KEYS_FILE = 'component_keys.yaml'
        
        def self.get_key(key_type, component_type, component_index, dtk_all_attributes)
          new(dtk_all_attributes).get_key(key_type, component_type, component_index)
        end
        def get_key(key_type, component_type, component_index)
          get_key_info(component_type, component_index).send(key_type.to_sym)
        end
        
        protected
        
        attr_reader :dtk_all_attributes
        
        def key_location_info
          @key_location_info ||= self.dtk_all_attributes.value(:key_location_info)
        end
        
        private
        
        def ret_s3_bucket
          self.key_location_info[:s3_bucket] || fail("unexpected that missing key_location_info['s3_bucket']")
        end
        
      end
    end
  end
end
