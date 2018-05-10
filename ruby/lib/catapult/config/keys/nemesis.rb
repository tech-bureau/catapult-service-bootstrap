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

        def nemesis_keys
          @nemesis_keys ||= ret_nemesis_keys
        end

        private

        def ret_nemesis_keys
          keys_array = self.raw_key_info['nemesis_generation'] || fail("Cannot compute nemesis hash")
          case keys_array.size
          when 1 
          then keys_array.first
          else
            fail "Unexpected that keys_array.size = #{keys_array.size} and not 1"
          end
        end

        def get_generation_info
          nemesis_generation_hash    = nemesis_keys['public'] || fail( "cannot find public address") 
          nemesis_signer_private_key = nemesis_keys['private'] || fail( "cannot find private address")

          GenerationInfo.new(
            Global.catapult_nework_identifier,
             nemesis_generation_hash,
             nemesis_signer_private_key
          )
        end
              
      end
    end
  end
end

 

