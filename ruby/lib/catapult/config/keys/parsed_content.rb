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
      class ParsedContent
        KeyInfo = Struct.new(:private, :public, :address, :index) # :index starts at 0
        
        def initialize(raw_hash)
          @parsed_hash = parse(raw_hash)
        end
        
        # returns a matching KeyInfo object  or raises an error if none exist
        def get_key_info(parse_key, index)
          get_key_info?(parse_key, index) || fail("Unexpected that key info not found for '#{parse_key}-#{index}'")
        end
        
        # returns an array of ParsedContent::KeyInfo objects
        def get_keys_info_array(parse_key)
          key_info_array(parse_key)
        end
        
        protected
        
        attr_reader :parsed_hash
        
        private
        
        def key_info_array(parse_key)
          self.parsed_hash[parse_key.to_sym] || fail("No keys for parse_key '#{parse_key}")
        end
        
        # returns a matching KeyInfo object if one exists        
        def get_key_info?(parse_key, index)
          key_info_array(parse_key).find { |key_info| key_info.index == index }
        end
        
        module KeyType
          def self.for_accounts
            :accounts
          end
          def self.for_harvesting
            :harvesting
          end
          def self.for_generation_hash
            :generation_hash
          end
          def self.for_signer_private_key
            :signer_private_key
          end
        end

        # Mapping from parse name to componenttype
        LEGAL_PARSE_KEYS_MAPPING = {
          Global::ParseKey.peer_nodes                    => :peer_node,
          Global::ParseKey.api_nodes                    => :api_node,
          Global::ParseKey.rest_gateways                => :rest_gateway,
          Global::ParseKey.nemesis_addresses            => KeyType.for_accounts,
          Global::ParseKey.nemesis_addresses_harvesting => KeyType.for_harvesting,
          Global::ParseKey.nemesis_generation_hash      => KeyType.for_generation_hash,
          Global::ParseKey.nemesis_signer_private_key   => KeyType.for_signer_private_key
        }
        LEGAL_PARSE_KEYS = LEGAL_PARSE_KEYS_MAPPING.keys
        
        def parse(raw_hash)
          raw_hash.inject({}) do |h, (raw_parse_key, raw_key_info_array)|
            parse_key = raw_parse_key.to_sym
            parse_key_index = LEGAL_PARSE_KEYS_MAPPING[parse_key] || 
                                   fail("Illegal component type '#{parse_key}'; legal values are: #{LEGAL_PARSE_KEYS.join(', ')}")
            h.merge(parse_key_index => parse_key_info_array(raw_key_info_array))
          end
        end
        
        def parse_key_info_array(raw_key_info_array)
          ret = []
          raw_key_info_array.each_with_index do |raw_key_info, index|
            ret << KeyInfo.new(hash_value(raw_key_info, :private), hash_value(raw_key_info, :public), hash_value(raw_key_info, :address), index)
          end
          ret
        end
        
        def hash_value(hash, key)
          hash[key.to_s] || hash[key.to_sym] || fail("Unexpecetd that cannot find ket '#{key}'")
        end
        
      end
    end
  end
end

 

