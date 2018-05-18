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
      require_relative('keys/component')
      require_relative('keys/parsed_content')
      require_relative('keys/nemesis')
      
      def initialize(input_attributes)
        @input_attributes = input_attributes
      end
      
      # returns an array of Content::KeyInfo objects
      def get_keys_info_array(parse_key)
        self.parsed_content.get_keys_info_array(parse_key)
      end

      def self.get_key_info(parse_key, input_attributes)
        new(input_attributes).get_key_info(parse_key)
      end

      # returns a matching Content::KeyInfo object or raises an error if none exist
      def get_key_info(parse_key, index = 0)
        self.parsed_content.get_key_info(parse_key, index)        
      end

      protected
      
      attr_reader :input_attributes
      
      def parsed_content
        @parsed_content ||= ParsedContent.new(self.raw_key_info)
      end

      def raw_key_info
        self.input_attributes[:keys] || fail("Missing :keys input")
      end

      private
      
      def raise_error_if_wrong_type(object, ruby_class)
        unless object.kind_of?(ruby_class)
          fail "Type of object at '#{self.file_path}' should be a '#{ruby_class}' put has type '#{object.class}'"
        end
        object
      end
      
    end
  end
end
 
