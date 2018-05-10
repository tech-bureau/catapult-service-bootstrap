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
 
