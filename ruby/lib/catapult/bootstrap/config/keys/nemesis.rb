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
  class Config
    class Keys
      class Nemesis < self
        module KeyType
          ARRAY = [
            :accounts,
            :harvesting,
            :harvesting_vrf,
            :generation_hash,
            :signer_private_key,
          ]
          class << self
            ARRAY.each { |el| define_method(el, lambda { el }) }
          end
        end

        GenerationInfo =  Struct.new(:network_identifier, :generation_hash, :signer_private_key)
        
        def account_keys_array
          @account_keys_array ||= get_keys_info_array(KeyType.accounts)
        end

        HarvestingPair = Struct.new(:signing, :vrf)
        def harvesting_pairs_array
          @harvesting_pairs_array ||= 
            begin
              array = []
              self.harvesting_keys_array.each_with_index do |base_key, i|
                array << HarvestingPair.new(base_key, self.harvesting_vrf_keys_array[i])
              end 
              array
            end
        end
        
        # TODO: this wil be deprecated
        def key_info_array
          # Important that harvesting goes first because picking keys up to limit from front of array
          @key_info_array ||= self.harvesting_keys_array + self.account_keys_array 
        end
        
        def generation_info
          @generation_info ||= GenerationInfo.new(Global.catapult_nework_identifier, self.generation_hash, self.signer_private_key)
        end

        def signer_private_key
          get_key_info(KeyType.signer_private_key).private
        end

        def network_public_key
          get_key_info(KeyType.signer_private_key).public
        end

        def generation_hash
          @generation_hash ||= get_key_info(KeyType.generation_hash).public
        end

        protected
        
        attr_reader :keys_handle

        def harvesting_vrf_keys_array
          @harvesting_vrf_keys_array ||= get_keys_info_array(KeyType.harvesting_vrf)
        end

        def harvesting_keys_array
          @harvesting_keys_array ||= get_keys_info_array(KeyType.harvesting)
        end


      end
    end
  end
end
