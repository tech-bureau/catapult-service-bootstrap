module Catapult
  class Config
    class Keys
      require_relative('keys/parsed_content')
      require_relative('keys/component')
      require_relative('keys/nemesis')
      
      DEFAULT_BASE_DIR = 'keys'
      
      def initialize(dtk_all_attributes)
        @dtk_all_attributes = dtk_all_attributes
      end
      
      # returns an array of Content::KeyInfo objects
      def get_keys_info_array(component_type)
        self.parsed_content.get_keys_info_array(component_type)
      end
      
      protected
      
      attr_reader :dtk_all_attributes
      
      def parsed_content
        @parsed_content ||= ParsedContent.new(self.dtk_all_attributes[:keys] || fail("Missing :keys input"))
      end
      
      private
      
      def file_path_with_base_dir(file_path)
        "#{DEFAULT_BASE_DIR}/#{file_path}"
      end
      
      # returns a matching Content::KeyInfo object or raises an error if none exist
      def get_key_info(component_type, component_index)
        self.parsed_content.get_key_info(component_type, component_index)        
      end
      
      def get_s3_file_content_array
        raise_error_if_wrong_type(get_s3_file_content_as_ruby_object, ::Array)
      end
      
      def get_s3_file_content_as_ruby_object
        ::YAML.load(S3Helper.get_file_content(self.s3_bucket, self.file_path))
      end
      
      def raise_error_if_wrong_type(object, ruby_class)
        unless object.kind_of?(ruby_class)
          fail "Type of object at '#{self.file_path}' should be a '#{ruby_class}' put has type '#{object.class}'"
        end
        object
      end
      
    end
  end
end
 

