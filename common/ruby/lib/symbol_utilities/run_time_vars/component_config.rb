module SymbolUtilities
  class RunTimeVars
    class ComponentConfig
      DEFAULT_OPERATION_TYPE = :copy_key
      DEFAULT_KEY_TYPE       = :private
      CONFIG_INPUT_FILENAME  = 'config-input.yaml'

      def initialize(source, identity_dir: nil)
#        @path             = identity_dir && "#{identity_dir}/#{CONFIG_INPUT_FILENAME}"
        @path             = "#{Directory.identity}/#{CONFIG_INPUT_FILENAME}"
        @address_position = source['address_position']
        @attribute_name   = source['key'] ||  fail("Missing source['key']")
        @type             = (source['type'] || DEFAULT_OPERATION_TYPE).to_sym
        @key_type         = (source['key_type'] || DEFAULT_KEY_TYPE).to_sym
        @donot_overwrite  = (source['donot_overwrite'].nil? ? false : source['donot_overwrite'])
      end
 
      attr_reader :attribute_name, :type, :key_type, :donot_overwrite

      def path
        @path || fail("@path is not set")
      end

      def address_position?
        @address_position
      end
      
      def hash
        @hash ||= RunTimeVars.yaml_file_to_hash(self.path)
      end

      def attributes
        @attributes ||= self.hash['attributes'] ||= {}
      end
      
      def value?
        @value ||= self.attributes[self.attribute_name]
      end

      def update_attribute!(attribute_name, value)
        self.attributes.merge!(attribute_name => value)
      end

    end
  end
end


                            
