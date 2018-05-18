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
module DTKModule
  module Catapult
    class Config
      class Keys
        class Content
          KeyInfo = Struct.new(:private, :public, :address, :index) # :index starts at 0
          
          def initialize(s3_bucket, file_path)
            require 'yaml'
            @s3_bucket = s3_bucket
            @file_path = file_path
          end
          
          def get_content!
            @hash ||= upload_from_s3_bucket_and_parse
            self
          end
          
          # returns a matching KeyInfo object  or raises an error if none exist
          def get_key_info(component_type, component_index)
            get_key_info?(component_type, component_index) || fail("Unexpected that key info not found for '#{component_type}-#{component_index}'")
          end
          
          # returns an array of Content::KeyInfo objects
          def get_keys_info_array(component_type)
            key_info_array(component_type)
          end
          
          protected
          
          attr_reader :file_path, :s3_bucket, :hash
          
          private
          
          # returns a matching KeyInfo object if one exists        
          def get_key_info?(component_type, component_index)
            key_info_array(component_type).find { |key_info| key_info.index == component_index }
          end
          
          # Mapping from parse name to componenttype
          LEGAL_COMPONENT_TYPES = {
            peer_nodes: :peer_node,
            api_nodes: :api_node,
            rest_gateways: :rest_gateway,
            nemesis_addresses: :nemesis_address
          }
          
          def upload_from_s3_bucket_and_parse
            raw_hash = get_s3_file_content_hash
            parse(raw_hash)
          end
          
          def parse(raw_hash)
            raw_hash.inject({}) do |h, (raw_component_type, raw_key_info_array)|
              component_type = LEGAL_COMPONENT_TYPES[raw_component_type.to_sym] || 
                               fail("Illegal component type '#{component_type}'; legal values are: #{LEGAL_COMPONENT_TYPES.join(', ')}")
              h.merge(component_type => parse_key_info_array(raw_key_info_array))
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
          
          def key_info_array(component_type)
            self.hash[component_type.to_sym] || fail("No keys for component_type '#{component_type}")
          end
          
          def get_s3_file_content_array
            raise_error_if_wrong_type(get_s3_file_content_as_ruby_object, ::Array)
          end
          
          def get_s3_file_content_hash
            raise_error_if_wrong_type(get_s3_file_content_as_ruby_object, ::Hash)
          end
          
          def get_s3_file_content_as_ruby_object
            ::YAML.load(get_s3_file_content)
          end
          
          def raise_error_if_wrong_type(object, ruby_class)
            unless object.kind_of?(ruby_class)
              fail "Type of object at '#{self.file_path}' should be a '#{ruby_class}' put has type '#{object.class}'"
            end
            object
          end
          
          def get_s3_file_content
            S3Helper.get_file_content(self.s3_bucket, self.file_path)
          end
          
        end
      end
    end
  end
end

 

