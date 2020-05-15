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
  class Config::Nemesis
    class BlockPropertiesFile
      module TemplateBindings
        XEM_TOTAL_SUPPLY   = "8'998'999'998'000'000"
	XEM_ACCOUNT_SUPPLY = "449'949'999'900'000"
        XEM_NUM_OF_ACCOUNTS = 20 # this has to equal ratio XEM_TOTAL_SUPPLY/XEM_ACCOUNT_SUPPLY

        def self.template_bindings(nemesis_keys_info, harvest_vrf_directory)
          key_info_array = nemesis_keys_info.key_info_array
          generation_info = nemesis_keys_info.generation_info
          {
            network_identifier: generation_info.network_identifier,
            nemesis_generation_hash: generation_info.generation_hash,
            nemesis_signer_private_key: generation_info.signer_private_key,
            harvesting_distribution: harvesting_distribution(key_info_array),
            currency_distribution: currency_distribution(key_info_array),
            transactions_directory: harvest_vrf_directory,
            bin_directory: BlockPropertiesFile.bin_directory,
            base_namespace: BlockPropertiesFile.base_namespace,
            mosaic_name: BlockPropertiesFile.mosaic_name
          }
        end

        # nemesis_keys_info = Config::Keys::Nemesis.get_nemesis_keys_info(self.keys_handle)
        
        private
        
        # TODO: hard coding until we figure out how to dynamically compute the mosaic ids in network config
        NUM_HARVEST_KEYS       = 4
        HARVEST_ACCOUNT_SUPPLY = "3'750'000"
        def self.harvesting_distribution(key_info_array)
          key_info_array[0...NUM_HARVEST_KEYS].map { |key_info| distribution(key_info, HARVEST_ACCOUNT_SUPPLY) }
        end
        
        NUM_CURRENCY_KEYS       = 20 # this has to equal ratio XEM_TOTAL_SUPPLY/XEM_ACCOUNT_SUPPLY
        CURRENCY_ACCOUNT_SUPPLY = XEM_ACCOUNT_SUPPLY
        def self.currency_distribution(key_info_array)
          key_info_array[0...NUM_CURRENCY_KEYS].map { |key_info| distribution(key_info, CURRENCY_ACCOUNT_SUPPLY) }
        end
        
        def self.distribution(key_info, amount)
          {
            address: key_info.address,
            amount:  amount
          }
        end
        
      end
      
    end
  end
end



