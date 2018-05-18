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
    class NemesisPropertiesFile
      module TemplateBindings
        XEM_TOTAL_SUPPLY   = "8'999'999'998'000'000"
        XEM_ACCOUNT_SUPPLY = "409'090'909'000'000"
        XEM_NUM_OF_ACCOUNTS = 22 # this has to equal ration XEM_TOTAL_SUPPLY/XEM_ACCOUNT_SUPPLY
        def self.template_bindings(nemesis_keys_info)
          key_info_array = nemesis_keys_info.key_info_array
          generation_info = nemesis_keys_info.generation_info
          {
            network_identifier: generation_info.network_identifier,
            nemesis_generation_hash: generation_info.generation_hash,
            nemesis_signer_private_key: generation_info.signer_private_key,
            xem: xem(key_info_array)
          }
        end
        
        private
        
        def self.xem(key_info_array)
          fail "Only have #{key_info_array.size} accounts, but need #{XEM_NUM_OF_ACCOUNTS}" if key_info_array.size < XEM_NUM_OF_ACCOUNTS
          {
            supply:  XEM_TOTAL_SUPPLY,
            distribution: key_info_array[0..XEM_NUM_OF_ACCOUNTS-1].map { |key_info| xem_distribution(key_info) }
          }
        end
        
        def self.xem_distribution(key_info)
          {
            address: key_info.address,
            amount:  XEM_ACCOUNT_SUPPLY,
          }
        end
      end
      
    end
  end
end



