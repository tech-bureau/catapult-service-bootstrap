module Catapult
  class Config
    class Keys
      class Nemesis < self
        GenerationInfo =  Struct.new(:network_identifier, :generation_hash, :signer_private_key)
        Info           =  Struct.new(:key_info_array, :generation_info)
        
        def self.get_nemesis_keys_info(dtk_all_attributes)
          new(dtk_all_attributes).get_nemesis_keys_info
        end
        
        def self.get_keys_info_array_for_harvesting(dtk_all_attributes)
          new(dtk_all_attributes).get_keys_info_array_for_harvesting
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
        
        attr_reader :dtk_all_attributes
        
        def keys_info_array_for_accounts
          @keys_info_array_for_accounts ||= get_keys_info_array(ParsedContent::NemesisType.for_accounts)
        end
        
        def keys_info_array_for_harvesting
          @keys_info_array_for_harvesting ||= get_keys_info_array(ParsedContent::NemesisType.for_harvesting)
        end
        
        private
        
        def get_generation_info
          hash = self.class.get_s3_file_content_hash(self.s3_bucket, file_path_with_base_dir(NEMESIS_GENERATION_INFO_FILE))
          GenerationInfo.new(hash_value(hash, :network_identifier, file_path), hash_value(hash, :nemesis_generation_hash, file_path), hash_value(hash, :nemesis_signer_private_key, file_path))
        end
        
        def ret_s3_bucket
          self.key_location_info[:s3_bucket] || fail("unexpected that missing key_location_info['s3_bucket']")
        end
        
        def hash_value(hash, key, s3_source)
          hash[key.to_s] || hash[key.to_sym] || fail("Missing value for key '#{key}' in S3 source '#{s3_source}'")
        end
        
      end
    end
  end
end

 

