module Catapult
  class Config
    class Keys
      class Nemesis < self
        GenerationInfo =  Struct.new(:network_identifier, :generation_hash, :signer_private_key)
        Info           =  Struct.new(:key_info_array, :generation_info)
        
        def self.get_nemesis_keys_info(input_attributes)
          new(input_attributes).get_nemesis_keys_info
        end
        
        def self.get_keys_info_array_for_harvesting(input_attributes)
          new(input_attributes).get_keys_info_array_for_harvesting
        end
        def get_keys_info_array_for_harvesting
          self.keys_info_array_for_harvesting
        end
        
        def get_nemesis_keys_info
          # Important that keys_info_array_for_harvesting goes first because picking keys up to limit from front of array
          keys_info_array = self.keys_info_array_for_harvesting + self.keys_info_array_for_accounts 
          Info.new(keys_info_array, get_generation_info)
        end
        
        protected
        
        attr_reader :input_attributes
        
        def keys_info_array_for_accounts
          @keys_info_array_for_accounts ||= get_keys_info_array(ParsedContent::NemesisType.for_accounts)
        end
        
        def keys_info_array_for_harvesting
          @keys_info_array_for_harvesting ||= get_keys_info_array(ParsedContent::NemesisType.for_harvesting)
        end
        
        private
        
        def get_generation_info
          GenerationInfo.new(
            hash_value(:network_identifier), 
            hash_value(:nemesis_generation_hash), 
            hash_value(:nemesis_signer_private_key)
          )
        end
        
        def hash_value(key)
          self.nemesis_hash[key.to_s] || self.raw_key_info[key.to_sym] || fail("Missing value for key '#{key}'")
        end
        
      end
    end
  end
end

 

