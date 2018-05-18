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

        def self.key_info_signer_private_key(input_attributes)
          get_key_info(ParsedContent::KeyType.for_signer_private_key, input_attributes)
        end

        def self.key_info_generation_hash(input_attributes)
          get_key_info(ParsedContent::KeyType.for_generation_hash, input_attributes)
        end

        protected
        
        attr_reader :input_attributes
        
        def keys_info_array_for_accounts
          @keys_info_array_for_accounts ||= get_keys_info_array(ParsedContent::KeyType.for_accounts)
        end
        
        def keys_info_array_for_harvesting
          @keys_info_array_for_harvesting ||= get_keys_info_array(ParsedContent::KeyType.for_harvesting)
        end

        def generation_hash
          get_key_info(ParsedContent::KeyType.for_generation_hash).public
        end

        def signer_private_key
          get_key_info(ParsedContent::KeyType.for_signer_private_key).private
        end

        private

        def get_generation_info
          GenerationInfo.new(Global.catapult_nework_identifier, self.generation_hash, self.signer_private_key)
        end
              
      end
    end
  end
end

 

