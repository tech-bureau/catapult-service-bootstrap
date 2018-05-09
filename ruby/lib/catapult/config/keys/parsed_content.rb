module Catapult
  class Config
    class Keys
      class ParsedContent
        KeyInfo = Struct.new(:private, :public, :address, :index) # :index starts at 0
        
        def initialize(raw_hash)
          @parsed_hash = parse(raw_hash)
        end
        
        # returns a matching KeyInfo object  or raises an error if none exist
        def get_key_info(component_type, component_index)
          get_key_info?(component_type, component_index) || fail("Unexpected that key info not found for '#{component_type}-#{component_index}'")
        end
        
        # returns an array of ParsedContent::KeyInfo objects
        def get_keys_info_array(component_type)
          key_info_array(component_type)
        end
        
        protected
        
        attr_reader :parsed_hash
        
        private
        
        def key_info_array(component_type)
          self.parsed_hash[component_type.to_sym] || fail("No keys for component_type '#{component_type}")
        end
        
        # returns a matching KeyInfo object if one exists        
        def get_key_info?(component_type, component_index)
          key_info_array(component_type).find { |key_info| key_info.index == component_index }
        end
        
        module NemesisType
          ACCOUNTS = :nemesis_address_for_accounts
          HARVESTING = :nemesis_address_for_harvesting
          def self.for_accounts
            ACCOUNTS
          end
          def self.for_harvesting
            HARVESTING
          end
        end

        # Mapping from parse name to componenttype
        LEGAL_COMPONENT_TYPES_MAPPING = {
          peer_nodes: :peer_node,
          api_nodes: :api_node,
          rest_gateways: :rest_gateway,
          nemesis_addresses: NemesisType.for_accounts,
          nemesis_addresses_harvesting: NemesisType.for_harvesting
        }
        LEGAL_COMPONENT_TYPES = LEGAL_COMPONENT_TYPES_MAPPING.keys
        
        def parse(raw_hash)
          raw_hash.inject({}) do |h, (raw_component_type, raw_key_info_array)|
            component_type = raw_component_type.to_sym
            component_type_index = LEGAL_COMPONENT_TYPES_MAPPING[component_type] || 
                                   fail("Illegal component type '#{component_type}'; legal values are: #{LEGAL_COMPONENT_TYPES.join(', ')}")
            h.merge(component_type_index => parse_key_info_array(raw_key_info_array))
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

 

